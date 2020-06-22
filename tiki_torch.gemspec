# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiki/torch/version'

Gem::Specification.new do |s|
  s.name        = 'tiki_torch'
  s.version     = Tiki::Torch::VERSION
  s.authors     = ['Adrian Madrid']
  s.email       = ['aemadrid@gmail.com']
  s.description = %q{Inter-service communication library for Ruby}
  s.summary     = %q{Tiki Torch is a Ruby asynchronous communication library through Amazon SQS.}
  s.homepage    = ''
  s.license     = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'aws-sdk-sqs', '~> 1'
  s.add_dependency 'concurrent-ruby', '~> 1.0'
  s.add_dependency 'concurrent-ruby-edge'
  s.add_dependency 'lifeguard', '0.3.0'
  s.add_dependency 'multi_json'
  s.add_dependency 'virtus'

  s.add_dependency 'pry'
  s.add_dependency 'colorize'

  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'fake_sqs'
  s.add_development_dependency 'rubocop'
end
