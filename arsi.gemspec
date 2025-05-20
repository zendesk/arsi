require './lib/arsi/version'

Gem::Specification.new do |spec|
  spec.name          = "arsi"
  spec.version       = Arsi::VERSION
  spec.authors       = ["Christopher Kintner"]
  spec.email         = ["ckintner@zendesk.com"]
  spec.summary       = "ActiveRecord SQL Inspector"
  spec.description   = "Puts your SQL under a microscope"
  spec.homepage      = "https://github.com/zendesk/arsi"
  spec.license       = "Apache License Version 2.0"

  spec.files         = `git ls-files -z lib README.md`.split("\x0")

  spec.required_ruby_version = '>= 3.2.0'

  spec.add_runtime_dependency "mysql2"
  spec.add_runtime_dependency "activerecord", ">= 7.0"

  spec.add_development_dependency "bump"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "maxitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "single_cov"
end
