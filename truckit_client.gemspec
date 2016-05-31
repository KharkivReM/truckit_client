# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'truckit_client/version'

Gem::Specification.new do |spec|
  spec.name          = "truckit_client"
  spec.version       = TruckitClient::VERSION
  spec.authors       = ["Rustam Mamedov"]
  spec.email         = ["KharkivReM@gmail.com"]
  spec.summary       = %q{Client for Truckit API.}
  spec.description   = %q{Client for Truckit API.}
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 3.0"
  spec.add_dependency 'rest-client'
  spec.add_dependency 'jbuilder'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "pry"
end
