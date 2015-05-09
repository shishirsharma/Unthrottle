require 'spec_helper'
require 'logger'

describe Unthrottle do
  describe Unthrottle::Configuration do
    subject { Unthrottle::Configuration.new }

    attribute_list = [
      :redis, :host, :port, :db,
      :key, :rate_limit_time, :limit,
      :logger,
      :log_level
    ]

    attribute_list.each do |attr|
      it { should respond_to attr }
    end
  end

  it 'has a version number' do
    expect(Unthrottle::VERSION).not_to be nil
  end

  subject {
    Unthrottle.tap do |unthrottle|
      unthrottle.configure do |config|
        config.host = "localhost"
        config.port = "6379"
        config.db = "test"

        config.key = "google_geocoding_api"
        config.rate_limit_time = 3# Millisecs
        config.limit = 3          # Number of api call during timeout

        config.logger = Logger.new(STDOUT)
      end
    end
  }

  it { should respond_to :configure }
  it { should respond_to :api}

  describe "#api" do
    it 'needs a block' do
      api_calls = 0
      expect {
        Unthrottle.api(timeout: 10)
      }.to raise_exception
    end

    context "when provided a block" do
      it 'Raise error once you hit timeout' do
        api_calls = 0
        expect {
          10.times do |api_calls|
            Unthrottle.api(timeout: 3) {
              api_calls += 1
              $stdout.puts "using google_geocoding_api api_call:#{api_calls} ts:#{Time.now}"
            }
          end
        }.to raise_exception(Timeout::Error)
      end

      it 'Lets you wait once you hit rate limit' do
        api_calls = 0
        expect {
          10.times do
            Unthrottle.api(timeout: 10) {
              api_calls += 1
              $stdout.puts "using google_geocoding_api api_call:#{api_calls} ts:#{Time.now}"
            }
          end
        }.not_to raise_exception
      end
    end
  end
end
