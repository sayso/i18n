# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)
require 'i18n/version'

Gem::Specification.new do |s|
  s.name         = "sayso-i18n"
  s.version      = I18n::VERSION
  s.authors      = ["SaySo"]
  s.email        = "sayso@truvolabs.com"
  s.homepage     = "http://github.com/sayso/i18n"
  s.summary      = "New wave Internationalization support for Ruby - forked and gemified for sayso"
  s.description  = "New wave Internationalization support for Ruby - forked and gemified for sayso"

  s.files        = Dir.glob("{ci,lib,test}/**/**") + %w(README.textile MIT-LICENSE CHANGELOG.textile)
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.5'

  s.add_development_dependency 'activesupport', '~> 3.0.0'
  s.add_development_dependency 'sqlite3-ruby'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'test_declarative'
end
