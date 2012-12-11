require 'fileutils'
require 'ethilvan/skins/chunky_png'

module EthilVan::Skins

   MINECRAFT_BASE_URL = 'http://s3.amazonaws.com/MinecraftSkins/'

   DEFAULT_SCALE = 4
   DEFAULT_CACHE = 6.hour.to_i

   SKINS_DIRECTORY = File.join EthilVan::ROOT, 'tmp', 'skins'
   FileUtils.mkdir_p SKINS_DIRECTORY

   module Helpers

      def get(username, scale = nil)
         scale ||= DEFAULT_SCALE

         filename = filename_for(username, scale)
         return filename unless update?(filename)

         response = Net::HTTP.get_response skin_uri_for username
         return char_skin(scale) unless response.code == '200'

         last_modified = Time.parse response['Last-Modified']
         if generate?(filename, last_modified)
            generate response.body, scale, filename
         end

         filename
      end

   private

      def filename_for(username, scale)
         "#{File.join(self::DIR, username)}_x#{scale}.png"
      end

      def update?(filename)
         !File.exists?(filename) || (Time.now - File.mtime(filename)) >= DEFAULT_CACHE
      end

      def skin_uri_for(username)
         URI("#{MINECRAFT_BASE_URL}#{username}.png")
      end

      def char_skin(scale)
         filename = filename_for('char', scale)
         unless File.exists? filename
            response = Net::HTTP.get skin_uri_for 'char'
            generate response, scale, filename
         end

         filename
      end

      def generate?(filename, last_modified)
         !File.exists?(filename) or File.mtime(filename) < last_modified
      end
   end

   module Preview

      extend Helpers

      DIR = File.join SKINS_DIRECTORY, 'preview'
      FileUtils.mkdir_p DIR
   end

   module Head

      extend Helpers

      DIR = File.join SKINS_DIRECTORY, 'head'
      FileUtils.mkdir_p DIR
   end
end
