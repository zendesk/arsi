# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arsi/version'

Gem::Specification.new do |spec|
  spec.name          = "arsi"
  spec.version       = Arsi::VERSION
  spec.authors       = ["Christopher Kintner"]
  spec.email         = ["ckintner@zendesk.com"]
  spec.summary       = "ActiveRecord SQL Inspector"
  spec.description   = "Puts your SQL under a microscope"
  spec.homepage      = "https://github.com/zendesk/arsi"
  spec.license       = "Apache License Version 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"

end
