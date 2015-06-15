# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sncf_api/version'

Gem::Specification.new do |spec|
  spec.name          = "sncf_api"
  spec.version       = SncfApi::VERSION
  spec.authors       = ["Thomas Lecavelier"]
  spec.email         = ["thomas@lecavelier.name"]

  spec.summary       = %q{Implements general SNCF open data API}
  spec.description   = %q{SNCF open source API exposes plenty of services. This gem implements its access for ruby. API available at https://data.sncf.com/api/documentation }
  spec.homepage      = "https://github.com/ook/sncf_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "http", "~> 0.8.12"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.5.2"
  spec.add_development_dependency "pry", "~> 0.10.1"
end
