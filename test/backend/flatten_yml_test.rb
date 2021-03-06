# encoding: utf-8
$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../')); $:.uniq!
require 'test_helper'
require 'backend/simple_test'

class I18nBackendFlattenYmlTest < I18nBackendSimpleTest
  class FlattenYmlBackend
    include I18n::Backend::Base
    include I18n::Backend::FlattenYml
  end
  
  def setup
    super
    I18n.backend = FlattenYmlBackend.new
  end
end

class I18nBackendFlattenYmlSpecificTest < Test::Unit::TestCase
  class FlattenYmlBackend
    include I18n::Backend::Base
    include I18n::Backend::FlattenYml
  end
  
  def setup
    @backend = FlattenYmlBackend.new
  end

  def assert_unified(expected, flattened)
    assert_equal expected, @backend.send(:unify_hash, flattened)
  end

  test "unify_hash works" do
    assert_unified(
      {:a=>'a', :b=>{:c=>'c', :f=>{:x=>'x', :y=>'y', :z=>'z'}}, :c=>{:d=>{:e=>'e'}}},
      {:a=>'a', :b=>{:c=>'c', :f=>{:x=>'x'}}, :"b.f.y" => "y", :"b.f.z" => "z", :"c.d.e"=>"e"}
    )
  end

  test "translate" do
    @backend.store_translations :en,  {:"a.b.c" => "foo", :x => {:y => {:z => "bar"}}}

    assert_equal({:c=>"foo"}, @backend.translate(:en, :"a.b"))
    assert_equal("foo", @backend.translate(:en, :"a.b.c"))

    assert_equal({:z=>"bar"}, @backend.translate(:en, :"x.y"))
    assert_equal("bar", @backend.translate(:en, :"x.y.z"))
  end

end
