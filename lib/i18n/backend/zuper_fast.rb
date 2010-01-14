#
#   I18n::Backend::Simple.send(:include, I18n::Backend::ZuperFast)
#
module I18n
  module Backend
    module ZuperFast
      include I18n::Backend::Fast

      protected

      #
      # Overwrites flatten_hash to unify hash keys first
      #
      # flatten_hash({:a=>"a", :b=>{:c=>"c}, :"g.h.j" => "j"})
      # => {:"g.h.j"=>"j", :g=>{:h=>{:j=>"j"}}, :"g.h"=>{:j=>"j"}, :"b.c"=>"c", :a=>"a", :b=>{:c=>"c"}}
      #
      def flatten_hash(hash)
        super(unify_hash(hash))
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