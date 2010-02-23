# encoding: utf-8

#
# Author: Krzysztof Knapik
#   
# Adds support for flatten translation file so they can contains flatten keys, e.g.:
# 
# en: 
#   activerecord.errors.messages.accepted: "must be accepted"
#   activerecord.errors.messages.blank: "can't be blank"
#
# So they can be easily a safely merged in case of SCM conflicts
# and easily edited and more readeable with large amount of YML data
# 
# I18n::Backend::Simple.send(:include, I18n::Backend::ZuperFast)
#

require 'active_support/core_ext/hash' unless Hash.methods.include?("deep_merge")

module I18n
  module Backend
    module ZuperFast
      include I18n::Backend::Fast

      protected

      #
      # Overwrites I18n::Backend::Fast#flatten_translations to unify hash keys before flattening
      #
      # flatten_hash({:a=>"a", :b=>{:c=>"c}, :"g.h.j" => "j"})
      # => {:"g.h.j"=>"j", :g=>{:h=>{:j=>"j"}}, :"g.h"=>{:j=>"j"}, :"b.c"=>"c", :a=>"a", :b=>{:c=>"c"}}
      #
      def flatten_translations(translations)
        super(unify_hash(translations))
      end

      #
      # Converts hash containing both flattened and unflattened keys
      # to only unflattened ones
      #
      # unify_hash({:a=>'a', :b=>{:c=>"c"}, :"g.h.j" => "j", :"g.h.k" => "k"})
      # => {:g=>{:h=>{:j=>"j", :k=>"k"}}, :a=>"a", :b=>{:c=>"c"}}
      #

      def unify_hash(hash)
        flattened_h, regular_h = hash.partition { |k, v| k.to_s.include?(I18n.default_separator) }.map { |a| Hash[a] }

        regular_h.deep_merge(deep_symbolize_keys(unwind_keys(flattened_h)))
      end

    end
  end
end