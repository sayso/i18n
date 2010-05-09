# encoding: utf-8

#
# Author: Krzysztof Knapik
#   
# Extend I18n backend to support flattened translation files,
# that they can contains flatten keys, e.g.:
# 
# en: 
#   activerecord.errors.messages.accepted: "must be accepted"
#   activerecord.errors.messages.blank: "can't be blank"
#
# This way they can be easily a safely merged in case of SCM conflicts
# and easily edited and more readeable with large amount of YML data
# 
# I18n::Backend::Simple.send(:include, I18n::Backend::FlattenYml)
#

module I18n
  module Backend
    module FlattenYml

      #
      # Overwrites #I18n::Backend::Base#store_translations
      # to unify translation keys before storing
      #
      def store_translations(locale, data, options = {})
        data = unify_hash(data)
        super(locale, data, options)
      end

      protected

      #
      # Converts hash containing both flattened and unflattened keys
      # to contain only unflattened/nested keys
      #
      # unify_hash({:a=>'a', :b=>{:c=>"c"}, :"g.h.j" => "j", :"g.h.k" => "k"})
      # => {:g=>{:h=>{:j=>"j", :k=>"k"}}, :a=>"a", :b=>{:c=>"c"}}
      #
      def unify_hash(hash, separator = I18n.default_separator)
        # Split hash to flattened and unflattened parts
        partitioned = hash.partition { |k, v| k.to_s.include?(separator) }

        # Hash[arr] does not work with ruby 1.8.6 - the trick with *inject* solves the isssue.
        flattened_h, regular_h = partitioned.map{|arr| arr.inject({}){ |hsh,kv| hsh[kv[0]]=kv[1]; hsh }}

        regular_h.deep_merge(unwind_keys(flattened_h, separator).deep_symbolize_keys)
      end

      #
      # Converts flattened hash into unflattened/nested one
      #   >> unwind_keys({ "a.b.c" => "d", "a.b.e" => "f", "a.g" => "h", "i" => "j" })
      #   => { "a" => { "b" => { "c" => "d", "e" => "f" }, "g" => "h" }, "i" => "j"}
      # Based on http://github.com/svenfuchs/i18n/commit/678fb6ad10ff136a095cc6fe2136a729428cc228
      #
      def unwind_keys(hash, separator)
        result = {}
        hash.each do |key, value|
          keys = key.to_s.split(separator)
          curr = result
          curr = curr[keys.shift] ||= {} while keys.size > 1
          curr[keys.shift] = value
        end
        result
      end

    end
  end
end