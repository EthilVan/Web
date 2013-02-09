# encoding: utf-8

module EthilVan::Assets

   class Base

      SOURCE = 'content'
      CACHE = 'tmp'
      MANIFEST_EXT = '.mf'
      DEST = EthilVan::Static::SOURCE_DIR

      class << self

         include Enumerable
         def each(&block)
            all.each(&block)
         end

         def all
            @list ||= Dir[manifest_paths].map { |mf| new(mf) }
         end

      private

         def manifest_paths
            File.join SOURCE, self::DirName, '*' + MANIFEST_EXT
         end
      end

      def initialize(manifest)
         @name = File.basename manifest, MANIFEST_EXT
         @manifest = manifest
      end

      def manifest
         @manifest
      end

      def files
         File.read(manifest).split("\n").map do |filepath|
            File.join SOURCE, self.class::DirName, filepath.strip
         end
      end

      def compile?(file)
         false
      end

      def dirty?(file, cached)
         return true if EthilVan.production?
         !File.exists?(cached) or File.mtime(file) > File.mtime(cached)
      end

      def compress?
         EthilVan.production? and respond_to? :compress
      end

      def output_file
         File.join DEST, self.class::DirName, "#@name.#{self.class::OutputExt}"
      end

      def compile
         out = output_file
         puts "### Génération de \"#{out}\"."

         result = ''
         files.each { |file| result << compiled(file) }
         result.gsub!('%%CACHE_BUSTER%%', EthilVan::Static::BASE_URL)
         result = compress result if compress?

         File.open(out, 'w') { |f| f << result }
         puts "### Fichier \"#{out}\" généré."
      end

      def compiled(file)
         return File.read(file) unless compile? file

         cached = file.gsub(/^#{SOURCE}/, "#{CACHE}/")
         if dirty?(file, cached)
            FileUtils.mkdir_p File.dirname cached
            if compile_asset(file, cached)
               puts "# Fichier \"#{file}\" compilé."
            else
               FileUtils.rm_f cached
               puts '# Une erreur est survenu durant ' +
                     "la compilation de \"#{file}\""
               exit 1
            end
         end

         return File.read cached
      end
   end
end
