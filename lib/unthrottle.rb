require 'unthrottle/version'
require 'redis'
require 'timeout'

module Unthrottle
  class Configuration
    attr_accessor :redis, :host, :port, :db,
                  :key, :rate_limit_time, :limit,
                  :logger,
                  :log_level

    def initialize
      @host = 'localhost'
      @port = 6379
      @db = 'test'

      # Key name => time out in sec
      @key = :global            # Api key name
      @rate_limit_time = 60     # Expire time for this key
      @limit = 10               # Api call limit in timeout periode
    end
  end

  class << self
    attr_accessor :config
  end

  def configure
    @config ||= Configuration.new
    yield(config) if block_given?
    # Create a redis connection if not provided with
    @config.redis ||=
      Redis.new(host: config.host, port: config.port,
                db: config.db)
    @config.logger ||= Logger.new(STDOUT)
  end

  # Register an Api Call in redis
  #
  # @param key Api key name to register call with
  # @return current count of this key
  def register_api_call(key)
    keyname = "Unthrottle:#{key}".to_sym # Puting key names in a namespace
    rate_limit_time = @config.rate_limit_time
    # This can possibly return nil and integer
    count = @config.redis.get(keyname).to_i
    # Run it as a redis transaction
    @config.redis.multi do |redis|
      redis.incr(keyname)
      # Set expire if this is a first time we call api
      if count == 0
        redis.expire(keyname, rate_limit_time)
      end
    end

    return count + 1
  end

  # Run an api with rate limit
  #
  # @param [Hash] opts input options
  # @options opts [Integer] :timeout milli seconds to wait before you retry api
  def api(timeout: 60)
    sleep_time = 100/1000.0     # 100 millisecs
    Timeout::timeout(timeout) do # secs
      loop do
        count = self.register_api_call(@config.key)
        @config.logger.debug("Attempt api with #{count}")
        if count <= @config.limit
          @config.logger.debug("Going through with #{count}")
          yield                 # Call the block provided
          return
        end
        @config.logger.info("Rate limit hit! going to sleep with #{sleep_time}")
        sleep(sleep_time)       # milli secs
        # Geometric sleep progression for now
        sleep_time += sleep_time
      end
    end
  end

  module_function :configure, :register_api_call, :api
end
