# Unthrottle [![Build Status](https://travis-ci.org/shishirsharma/Unthrottle.svg?branch=master)](https://travis-ci.org/shishirsharma/Unthrottle) [![Coverage Status](https://coveralls.io/repos/shishirsharma/Unthrottle/badge.svg)](https://coveralls.io/r/shishirsharma/Unthrottle)

Centralized rate limiting for ruby processes sharing a single API using Redis.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unthrottle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unthrottle

## Usage

```ruby
    require 'unthrottle'
    require 'logger'

    Unthrottle.configure do |config|
      config.host = "localhost"
      config.port = "6379"
      config.db = "1"

      config.key = "google_geocoding_api"
      config.rate_limit_time = 3 # Millisecs
      config.limit = 3           # Number of api call during timeout

      config.logger = Logger.new(STDOUT)
    end

    Unthrottle.api(:timeout => 10) {
       logger.info("this is it")
       #<Your method call>
    }
```

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `bin/console` for an interactive prompt that
will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release` to create a git
tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/shishirsharma/Unthrottle/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
