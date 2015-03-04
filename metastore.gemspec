# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metastore/version'

Gem::Specification.new do |spec|
  spec.name          = "metastore"
  spec.version       = Metastore::VERSION
  spec.authors       = ["Ash McKenzie"]
  spec.email         = ["ash@the-rebellion.net"]

  spec.summary       = %q{Store and retrieve meta information with ease}
  spec.homepage      = "https://github.com/ashmckenzie/metastore"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
