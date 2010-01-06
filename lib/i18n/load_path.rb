# encoding: utf-8

# Authors::   Krzysztof Knapik (http://www.knapo.net),
# License::   MIT
#
# Better paths registering.
# It can load single file
#   I18n.load_path << 'path/to/locale/en.yml'
# or load all translation data files in specific directory
#   I18n.load_path << 'path/to/locale/'
# or load all translation data files by given rule:
#   I18n.load_path << 'path/to/locale/*.yml'
module I18n
  class LoadPath < Array

    def <<(path)
      push path
    end

    def push(*paths)
      super(*paths.map{|path| locale_files(path) }.flatten.uniq.sort)
    end

    protected

    def locale_files(path)
      if File.file?(path) 
        [path]
      elsif File.directory?(path) 
        Dir[File.join(path, '/**/*.{rb,yml,po}')]
      else 
        Dir[path]
      end
    end

  end
end