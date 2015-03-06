require 'fakefs/safe'
require 'fakefs/spec_helpers'

require 'pry-byebug'
Pry.config.history.should_load = false
Pry.config.history.should_save = false

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

require 'metastore'
