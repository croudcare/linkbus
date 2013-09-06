# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linkedcare/version'

Gem::Specification.new do |spec|
  spec.name          = "linkbus"
  spec.version       = Linkedcare::VERSION
  spec.authors       = ["Thiago Dantas"]
  spec.email         = ["thiago.teixeira.dantas@gmail.com"]
  spec.description   = %q{Message Bus Abstraction}
  spec.summary       = %q{Backed by RabbitMQ Message Bus}
  spec.homepage      = "https://github.com/croudcare/linkedcare-bus"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['linkbus']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "=2.14.1"
  spec.add_development_dependency "rake" , "=10.1.0"
  spec.add_development_dependency "mocha", "=0.14.0"
  spec.add_development_dependency "rails", "3.2.13"
  spec.add_development_dependency "pry"



  spec.add_dependency "active_model_serializers", "0.8.1"
  spec.add_dependency "eventmachine" , "1.0.3"
  spec.add_dependency "bunny", "0.10.5"
  spec.add_dependency "amqp", "1.0.2"

end
