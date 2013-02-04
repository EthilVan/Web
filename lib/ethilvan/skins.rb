require 'pathname'

module EthilVan::Skins

   SKINS_DIRECTORY = Pathname.new(EthilVan::ROOT).join('tmp', 'skins')

   class Skin

      def self.directory
         @directory
      end

      def self.dirname(dirname)
         @directory = SKINS_DIRECTORY.join(dirname)
         @directory.mkpath
      end

      dirname 'raw'

      def self.raw_for(username)
         raw = Skin.new(username)
         raw = Skin.new('char') unless raw.exist?
         return raw
      end

      attr_reader :username
      attr_reader :scale

      def initialize(username)
         @username = username
         @file = self.class.directory.join filename username
      end

      def get
         @file.to_s
      end

      def exist?
         @file.exist?
      end

      def mtime
         @file.mtime
      end

      def need_update?(time)
         !exist? or mtime < time
      end

      def replace(contents)
         @file.open('wb') { |f| f << contents }
      end

   private

      def dir
         'raw'
      end

      def filename(name)
         name + '.png'
      end
   end

   class GeneratedSkin < Skin

      def initialize(username, scale, raw = nil)
         @scale = scale
         super(username)
         @raw ||= Skin.raw_for(username)
      end

      def get
         if !exist? or need_update? @raw.mtime
            generate
         end

         return super
      end

      def filename(name)
         "#{name}_x#@scale.png"
      end
   end

   class Preview < GeneratedSkin

      dirname 'preview'
   end

   class Head < GeneratedSkin

      dirname 'head'
   end

   PREGENERATED = {
      Head    => [ 8 ],
      Preview => [ 5 ]
   }
end

require 'ethilvan/skins/chunky_png'
