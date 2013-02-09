require 'rainpress'

module EthilVan::Assets

   class Style < Base

      DirName = 'style'
      OutputExt = 'css'
      IncludePath = [
         "#{SOURCE}/#{DirName}/bootstrap",
         "#{SOURCE}/#{DirName}/include",
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
         self.class.included_files.any? do |f|
            File.mtime(f) > File.mtime(cached)
         end
      end

      def compile_asset(file, dest)
         include_path = IncludePath * File::PATH_SEPARATOR
         cmd = 'lessc'
         cmd << " --include-path=#{include_path}"
         cmd << " --rootpath=#{EthilVan::Static::BASE_URL}"
         cmd << " #{file} #{dest}"
         system cmd
      end

      def compress(source)
         Rainpress.compress source
      end
   end
end
