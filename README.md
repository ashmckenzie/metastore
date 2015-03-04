# Metastore

[![Gem Version](https://badge.fury.io/rb/metastore.svg)](http://badge.fury.io/rb/metastore)
[![Code Climate](https://codeclimate.com/github/ashmckenzie/metastore/badges/gpa.svg)](https://codeclimate.com/github/ashmckenzie/metastore)
[![Build Status](https://travis-ci.org/ashmckenzie/metastore.svg?branch=wip)](https://travis-ci.org/ashmckenzie/metastore)
[![Dependency Status](https://gemnasium.com/ashmckenzie/metastore.svg)](https://gemnasium.com/ashmckenzie/metastore)

Store and retrieve meta information with ease

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metastore'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metastore

## Usage

There are four public methods hanging off `Metastore::Cabinet`:

* `#get('key')` or `<Metastore::Cabinet instance>['key']`
* `#set('key', 'value')` or `<Metastore::Cabinet instance>['key'] = 'value'`
* `#clear!`
* `#contents`

### Setup

```ruby
require 'metastore'

file = File.join(ENV['HOME'], '.metadata.yaml')
store = Metastore::Cabinet.new(file)
```

### Basic example

```ruby
store.clear!
=> true

store.contents
=> {}

store.get('key')
=> nil

store.set('key', 'value')
=> true

store.contents
=> {"key"=>"value"}

store.get('key')
=> "value"
```

### Advanced examples

When setting values, you can nest both keys and values:

```ruby
store.clear!
=> true

store.contents
=> {}

store.get('key1.key2')
=> nil

store.set('key1.key2', 'key.key2.value')
=> true

store.contents
=> {"key1"=>{"key2"=>"key.key2.value"}}

store.set('key3.key4', { 'key' => 'value' })
=> true

store.contents
=> {"key1"=>{"key2"=>"key.key2.value"}, "key3"=>{"key4"=>{"key"=>"value"}}}
```

You can also use Hash notation:

```ruby
store.clear!
=> true

store.contents
=> {}

store['key1.key2']
=> nil

store['key1.key2'] = 'key.key2.value'
=> true

store.contents
=> {"key1"=>{"key2"=>"key.key2.value"}}

store['key3.key4'] = { 'key' => 'value' }
=> true

store.contents
=> {"key1"=>{"key2"=>"key.key2.value"}, "key3"=>{"key4"=>{"key"=>"value"}}}
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/ashmckenzie/metastore/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
