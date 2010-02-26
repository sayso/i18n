# encoding: utf-8
$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../')); $:.uniq!
require 'test_helper'
require 'backend/simple_test'

class I18nBackendFastTest < I18nBackendSimpleTest
  class FastWindBackend
    include I18n::Backend::Base
    include I18n::Backend::FastWind
  end
  
  def setup
    super
    I18n.backend = FastWindBackend.new
  end
end

class I18nBackendFastWindSpecificTest < Test::Unit::TestCase
  class FastWindBackend
    include I18n::Backend::Base
    include I18n::Backend::FastWind
  end
  
  def setup
    @backend = FastWindBackend.new
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
    unified_hash =  @backend.send(:unify_hash, {:"a.b.c" => "foo", :x => {:y => {:z => "bar"}}})
    @backend.store_translations :en, @backend.send(:wind_keys, unified_hash, nil, true)

    assert_equal({:c=>"foo"}, @backend.translate(:en, :"a.b"))
    assert_equal("foo", @backend.translate(:en, :"a.b.c"))

    assert_equal({:z=>"bar"}, @backend.translate(:en, :"x.y"))
    assert_equal("bar", @backend.translate(:en, :"x.y.z"))
  end

end
