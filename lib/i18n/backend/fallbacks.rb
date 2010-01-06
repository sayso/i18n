# encoding: utf-8

# I18n locale fallbacks are useful when you want your application to use
# translations from other locales when translations for the current locale are
# missing. E.g. you might want to use :en translations when translations in
# your applications main locale :de are missing.
#
# To enable locale fallbacks you can simply include the Fallbacks module to
# the Simple backend - or whatever other backend you are using:
#
#   I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
module I18n
  @@fallbacks = nil

  class << self
    # Returns the current fallbacks implementation. Defaults to +I18n::Locale::Fallbacks+.
    def fallbacks
      @@fallbacks ||= I18n::Locale::Fallbacks.new
    end

    # Sets the current fallbacks implementation. Use this to set a different fallbacks implementation.
    def fallbacks=(fallbacks)
      @@fallbacks = fallbacks
    end
  end

  module Backend
    module Fallbacks
      # Overwrites the Base backend translate method so that it will try each
      # locale given by I18n.fallbacks for the given locale. E.g. for the
      # locale :"de-DE" it might try the locales :"de-DE", :de and :en
      # (depends on the fallbacks implementation) until it finds a result with
      # the given options. If it does not find any result for any of the
      # locales it will then raise a MissingTranslationData exception as
      # usual.
      #
      # The default option takes precedence over fallback locales, i.e. it
      # will first evaluate a given default option before falling back to
      # another locale.
      #
      def translate(locale, key, options = {})
        I18n.fallbacks[locale].each do |fallback|
          begin
            result = super(fallback, key, options)
            return result unless result.nil?
          rescue I18n::MissingTranslationData
          end
        end
        raise(I18n::MissingTranslationData.new(locale, key, options))
      end

      #
      # Overwrites the Base backend localize method so that it will try each
      # locale given by I18n.fallbacks for the given locale. E.g. for the
      # locale :"de-DE" it might try the locales :"de-DE", :de and :en
      # (depends on the fallbacks implementation) until it finds a result with
      # the given options. If it does not find any result for any of the
      # locales it will then raise a MissingTranslationData exception as
      # usual.
      #
      # The default option takes precedence over fallback locales, i.e. it
      # will first evaluate a given default option before falling back to
      # another locale.
      #
      def localize(locale, object, format = :default, options = {})
        I18n.fallbacks[locale].each do |fallback|
          begin
            result = super(fallback, object, format, options)
            return result unless result.nil?
          rescue I18n::MissingTranslationData
          end
        end
        raise(I18n::MissingTranslationData.new(locale, "#{object.respond_to?(:sec) ? 'time' : 'date'}.formats.#{format}", options))
      end

      #
      # Overwrites the Base backend localize method so that it will try each
      # locale given by I18n.fallbacks for the given locale. E.g. for the
      # locale :"de-DE" it might try the locales :"de-DE", :de and :en
      # (depends on the fallbacks implementation) until it finds a result with
      # the given options.
      #
      def pluralizer(locale)
        I18n.fallbacks[locale].each do |fallback|
          pluralizers[locale] ||= lookup(fallback, :'i18n.plural.rule') and break
        end unless pluralizers[locale]
        pluralizers[locale]
      end

    end
  end
end
