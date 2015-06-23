# SncfApi

Ruby gem to consume SNCF API (available from https://data.sncf.com/api)

This API let you access SNCF routes, schedules, stop points, etc.

Note: you have to request a user token from SNCF to use this API, so this gem (https://data.sncf.com/api/register)

[![Build Status](https://travis-ci.org/ook/sncf_api.svg)](https://travis-ci.org/ook/sncf_api)
[![Code Climate](https://codeclimate.com/github/ook/sncf_api/badges/gpa.svg)](https://codeclimate.com/github/ook/sncf_api)

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

# Remember that calling #instance will always return the same instance for a given token, so instead of keeping a req reference, you can just call instance again:
req.object_id == SncfApi::Request.instance(api_token: 'YOURTOKEN')
=> true

# At this level, you can build raw requests like this:
resp = req.fetch('/coverage/sncf/stop_areas')
=> #<SncfApi::Response:0x008fe8456 … >
resp.content
=> { … } # Giant Hash containing the response

```

Note that the `content` is not the whole response, but only the current page. You can use #each_page and pass it a block that'll receive each page content as param:

```ruby
stop_point_count = 0
resp.each_page { |page_content| stop_point_count += page_content['stop_points'].length }
=> #<SncfApi::Response:0x008fe8456 … >
stop_points.count
=> 3809
# Yes, there's an easier way to get the total_count on every page of the API, but that's
# just an example:
req.pagination['total_result']
=> 3809

# Have a look to your plan consumption :
req.countdown
=> {:per_day=>2843, :per_month=>89843, :per_month_started_at=>2015-06-23 11:35:41 UTC, :per_day_started_at=>2015-06-23 11:35:41 UTC}
```

Now you have all tools to explore SNCF API in your hands. In next iterations, I'll add some high-level wrappers for the different entities.
For now, just read the API doc! https://data.sncf.com/api/documentation

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/ook/sncf_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
