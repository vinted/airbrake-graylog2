# Airbrake::Graylog2

[![Build Status](https://secure.travis-ci.org/friendlyfashion/airbrake-graylog2.png)](http://travis-ci.org/friendlyfashion/airbrake-graylog2)

Extend airbrake gem to allow sending exceptions to Graylog2 server.

## Installation

Add this line to your application's Gemfile:

    gem 'airbrake-graylog2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install airbrake-graylog2

## Usage

    Airbrake.configure do |config|
      config.host = "localhost"
      config.port = 12201

      config.graylog2_facility = "my-custom-facility"

      config.graylog2_extra_args[:sample1] = "Test"
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
