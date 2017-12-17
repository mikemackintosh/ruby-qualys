# Created by hand, like a real man
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qualys/version'

Gem::Specification.new do |s|
  s.name        = 'qualys'
  s.version     = Qualys::VERSION
  s.date        = '2017-12-17'
  s.summary     = 'qualys API Client'
  s.description = 'Easily interface with the qualys for consuming events'
  s.authors     = ['Mike Mackintosh']
  s.email       = 'm@zyp.io'
  s.homepage    =
    'http://github.com/mikemackintosh/ruby-qualys'

  s.license       = 'MIT'

  s.require_paths = ['lib']
  s.files         = `git ls-files -z`.split("\x0")
  # s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'erubis'
  s.add_dependency 'httparty', '~> 0.15'
  s.add_dependency 'json'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
