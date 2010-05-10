# encoding: utf-8
$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../')); $:.uniq!
require 'test_helper'
require 'api'

class I18nFlattenYmlBackendApiTest < Test::Unit::TestCase
  include Tests::Api::Basics
  include Tests::Api::Defaults
  include Tests::Api::Interpolation
  include Tests::Api::Link
  include Tests::Api::Lookup
  include Tests::Api::Pluralization
  include Tests::Api::Procs
  include Tests::Api::Localization::Date
  include Tests::Api::Localization::DateTime
  include Tests::Api::Localization::Time
  include Tests::Api::Localization::Procs

  class FlattenYmlBackend
    include I18n::Backend::Base
    include I18n::Backend::FlattenYml
  end

  def setup
    I18n.backend = FlattenYmlBackend.new
    super
  end

  test "make sure we use the FlattenYmlBackend backend" do
    assert_equal FlattenYmlBackend, I18n.backend.class
  end
end