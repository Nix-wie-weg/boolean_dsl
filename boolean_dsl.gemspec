# -*- encoding: utf-8 -*-
require File.expand_path('../lib/boolean_dsl/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'boolean_dsl'
  s.version     = BooleanDsl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Brenton Fletcher']
  s.email       = ['brentonf@jobready.com.au']
  s.homepage    = 'http://github.com/jobready/boolean_dsl'
  s.summary     = 'Gem for parsing and executing the boolean algebra in a ruby-like DSL.'
  s.description = 'Coming Soon'
  s.license       = 'MIT'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'factory_bot', '~> 4.4'
  s.add_development_dependency 'cane', '~> 2.6'
  s.add_development_dependency 'byebug', '~> 2.7'
  s.add_development_dependency 'rake', '~> 10.1'
  s.add_dependency 'activesupport'
  s.add_dependency 'parslet'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
