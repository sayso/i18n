#! /usr/bin/ruby
$:.unshift File.expand_path('../../lib', __FILE__)

require 'i18n'
require 'benchmark'
require 'yaml'

DATA_STORES = ARGV.delete("-ds")
N = (ARGV.shift || 10000).to_i
YAML_HASH = YAML.load_file(File.expand_path("example.yml", File.dirname(__FILE__)))

I18n.backend = I18n::Backend::Simple.new
I18n.backend.store_translations *(YAML_HASH.to_a.first)
I18n.locale = :en

[true, false, true, false].each do |val|
I18n::Backend::Base.enabled = val
puts "Enabled #{val}"
time = Benchmark.realtime{N.times{
  I18n.t("activerecord.errors.models.user.blank", :model => "user", :attribute => "name")
}}
puts "With interpolations:                      " + sprintf("%8.2f ms", time * 1000)

time = Benchmark.realtime{N.times{
  I18n.t("activerecord.errors.models.user.attributes.login.blank", :model => "user", :attribute => "name")
}}
puts "No interpolations but values passed:      " + sprintf("%8.2f ms", time * 1000)

time = Benchmark.realtime{N.times{
  I18n.t("activerecord.errors.models.user.attributes.login.blank")
}}
puts "No interpolations and and no values passed:" + sprintf("%8.2f ms", time * 1000)
puts '-------------------'
end
