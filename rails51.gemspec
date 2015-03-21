# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails51/version'

Gem::Specification.new do |spec|
  spec.name          = "rails51"
  spec.version       = Rails51::VERSION
  spec.authors       = ["Enrico Carlesso"]
  spec.email         = ["enricocarlesso@gmail.com"]
  spec.summary       = %q{Rails51 add some capistrano task and some project sanity checker}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
