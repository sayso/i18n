#
#   I18n::Backend::Simple.send(:include, I18n::Backend::ZuperFast)
#
module I18n
  module Backend
    module ZuperFast
      include I18n::Backend::Fast

      protected

      #
      # Converts hash containing both flattened and unflattened keys
      # to fully winded
      #
      # zuper_hash({:a=>'a', :b=>{:c=>'c', :d=>'d', :f=>{:x=>'x'}}, :"g.h.j" => "j", :"g.h.k" => "k"})
      # =>
      # {
      #  :"b.f.x"=>"x", :"g.h.j"=>"j", :"b.c"=>"c", :g=>{:h=>{:j=>"j", :k=>"k"}}, :"g.h.k"=>"k", :a=>"a",
      #  :"g.h"=>{:j=>"j", :k=>"k"}, :"b.d"=>"d", :b=>{:d=>"d", :f=>{:x=>"x"}, :c=>"c"}, :"b.f"=>{:x=>"x"}
      # }
      #
      def flatten_hash(hash)
        super(unify_and_flatten_hash(hash))
      end

      def unify_hash(hash)
        flattened_h, regular_h = hash.partition { |k, v| k.to_s.include?(I18n.default_separator) }.map { |a| Hash[a] }

        regular_h.deep_merge(flatten_and_symbolize_keys(flattened_h))
      end

      #
      # Expand keys chained by the the given separator through nested Hashes
      # Similar to I18n::Backend::Helpers#unwind_keys but additinaly deeply symbolize keys
      # I might be done in 2 steps using I18n::Backend::Helpers#deep_symbolize_keys,
      # but additional *each* loop makes it much slower
      #
      def flatten_and_symbolize_keys(hash, separator = ".")
        result = {}
        hash.each do |key, value|
          keys = key.to_s.split(separator)
          curr = result
          curr = curr[((k = keys.shift).to_sym rescue k)] ||= {} while keys.size > 1
          curr[((k = keys.shift).to_sym rescue k)] = value
        end
        result
      end

    end
  end
end