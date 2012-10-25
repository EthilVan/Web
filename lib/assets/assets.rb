# encoding: utf-8

require 'fileutils'
require 'os'
require 'net/http'
require 'rainpress'

module EthilVan::Assets

   class Base

      SRC = "assets"
      CACHE = ".assets_cache"
      MANIFEST_EXT = ".mf"
      DEST = "public"

      Dir.mkdir CACHE unless Dir.exists? CACHE

      def initialize(name)
         @name = name
      end

      def manifest_path
         File.join SRC, self.class::DirName, @name + MANIFEST_EXT
      end

      def manifest
         File.read(manifest_path).split("\n").map do |filepath|
            File.join SRC, self.class::DirName, filepath.strip
         end
      end

      def included_files
         []
      end

      def compile?(file)
         false
      end

      def dirty?(file, cached)
         !File.exists?(cached) or File.mtime(file) > File.mtime(cached)
      end

      def compress?
         EthilVan.production? and respond_to? :compress
      end

      def output_file
         File.join DEST, self.class::DirName,
               "#@name.#{self.class::OutputExt}"
      end

      def compile
         out = output_file
         puts "### Génération de \"#{out}\"."
         result = ""
         manifest.each do |file|
            result << compiled(file)
         end

         if compress?
            result = compress result
         end

         File.open(out, "w") { |f| f << result }
         puts "### Fichier \"#{out}\" généré."
      end

      def compiled(file)
         unless compile? file
            return File.read file
         end

         cached = file.gsub(/^#{SRC}/, "#{CACHE}/#{EthilVan::ENV}")
         if dirty?(file, cached)
            FileUtils.mkdir_p File.dirname cached
            if compile_asset(file, cached)
               puts "# Fichier \"#{file}\" compilé."
            else
               puts "# Une erreur est survenu durant " +
                     "la compilation de \"#{file}\""
               exit 1
            end
         end

         return File.read cached
      end
   end

   class Style < Base

      DirName = "style"
      OutputExt = "css"
      IncludePath = [
         "#{SRC}/#{DirName}/bootstrap",
         "#{SRC}/#{DirName}/include"
      ]

      def initialize(*args)
         super(*args)
         @included_files = IncludePath.map { |p| Dir[p + "/**/*"] }.flatten

      end

      def included_files
         @included_files
      end

      def compile?(file)
         File.extname(file) == ".less"
      end

      def dirty?(file, cached)
         return true if super(file, cached)
         included_files.map { |f| File.mtime f }.max > File.mtime(cached)
      end

      def compile_asset(file, dest)
         include_path = IncludePath * (OS.windows? ? ';' : ':')
         system "lessc --include-path=#{include_path} #{file} #{dest}"
      end

      def compress(source)
         Rainpress.compress source
      end
   end

   class Script < Base

      DirName = "scripts"
      OutputExt = "js"

      def compile?(file)
         File.extname(file) == ".ts"
      end

      def compile_asset(file, dest)
         system "tsc --out #{dest} #{file}"
      end

      def compress(source)
         response = Net::HTTP.post_form(
            URI.parse("http://closure-compiler.appspot.com/compile"),
            output_info: "compiled_code",
            compilation_level: "SIMPLE_OPTIMIZATIONS",
            js_code: source
         )
         return response.body
      end
   end
end
