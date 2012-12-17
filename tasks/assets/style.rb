require 'rainpress'

module EthilVan::Assets

   class Style < Base

      DirName = 'style'
      OutputExt = 'css'
      IncludePath = [
         "#{SRC}/style/bootstrap",
         "#{SRC}/#{DirName}/include"
      ]

      def self.included_files
         @include_files ||= IncludePath.map { |p| Dir[p + '/**/*'] }.flatten
      end

      def initialize(*args)
         super(*args)
      end

      def compile?(file)
         File.extname(file) == '.less'
      end

      def dirty?(file, cached)
         return true if super(file, cached)
         self.class.included_files.map do |f|
            File.mtime f
         end.max > File.mtime(cached)
      end

      def compile_asset(file, dest)
         include_path = IncludePath * File::PATH_SEPARATOR
         system "lessc --include-path=#{include_path} #{file} #{dest}"
      end

      def compress(source)
         Rainpress.compress source
      end
   end
end
