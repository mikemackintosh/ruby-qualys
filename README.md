# Ruby Qualys API v2
A Ruby extension for interfacing with Qualys v2 API.

[![](http://ruby-gem-downloads-badge.herokuapp.com/qualys)](https://rubygems.org/gems/qualys)

[![Dependency Status](https://gemnasium.com/mikemackintosh/ruby-qualys.svg)](https://gemnasium.com/mikemackintosh/ruby-qualys)

[![Gem Version](https://badge.fury.io/rb/qualys.svg)](https://rubygems.org/gems/qualys)

### Introduction

I had the need to pull stats and details from Qualys automatically to collect and alert on metrics. Let's face it, in 2015, email alerts just don't cut it anymore.

## Installation

Like any other gem:

```shell
gem install qualys
```

## Usage

Below you can find details on the configuration and usage of the Qualys API Client.

### Configuration

Before utilizing the API, you must configure it. You can configure it with a block like below, or by passing in a `Hash#` or load a yaml file.
```ruby
Qualys.configure do |config|
  config.username = @email
  config.password = @password
end
```

or configure using a `yaml` doc:

```ruby
Qualys::Config.load!("config/qualys.yaml")
```

### Getting Scans

You can easily get a list of all scans within your Qualys account by accessing the following methods:

```ruby
scans = Qualys::Scans.all
```

## References

The API was built using the following documentation: 

  - https://www.qualys.com/docs/qualys-api-v2-quick-reference.pdf
  - https://www.qualys.com/docs/qualys-api-v2-user-guide.pdf?_ga=1.246313805.857253578.1427813387