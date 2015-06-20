# SncfApi

Ruby gem to consume SNCF API (available from https://data.sncf.com/api)

This API let you access SNCF routes, schedules, stop points, etc.

Note: you have to request a user token from SNCF to use this API, so this gem (https://data.sncf.com/api/register)

[![Build Status](https://travis-ci.org/ook/sncf_api.svg)](https://travis-ci.org/ook/sncf_api)

## Installation

Add this line to your application's Gemfile:

Note: I haven't published the gem yet. For now point to this github account:

```ruby
gem 'sncf_api', git: 'https://github.com/ook/sncf_api.git', branch: 'master'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sncf_api

## Usage

You have to pass your token either via environment variable `ENV['SNCF_API_TOKEN']` or via constructor.

```ruby
require 'sncf_api' # eventually

# Take an instance linked to your API TOKEN. You can avoid passing api_token if ENV['SNCF_API_TOKEN'] is defined
req = SncfApi::Request.instance(api_token: 'YOURTOKEN')
=> #<SncfApi::Request:0x007f95ab1162a8 @api_token="YOURTOKEN", @countdown={:per_day=>2997, :per_month=>89997, :per_month_started_at=>2015-06-19 12:01:03 UTC, :per_day_started_at=>2015-06-19 12:01:03 UTC}, @plan={:per_day=>3000, :per_month=>90000}>

# At this level, you can build raw requests like this:
req.fetch('/coverage/sncf/stop_areas')
=> { … } # giant Hash instance
# Note that if the mime type is json, it's automatically loaded into Hash. Raw String will be returned if it's not the case.

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/ook/sncf_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
