require 'fileutils'
require 'emoji'

module EthilVan::Emoji

   BLACKLIST = [
      "ant",
      "arrows_clockwise",
      "clock.+",
      "copyright",
      "curly_loop",
      "currency_exchange",
      "end",
      "heavy_.+",
      "musical_score",
      "notes",
      "on",
      "registered",
      "soon",
      "tm",
      "wavy_dash",
      "u[567].+"
   ]

   FILENAME_FILTERS = [
      ["+", "plus"]
   ]

   def self.install
      blacklist = BLACKLIST.map do |pattern|
         /^#{pattern}$/
      end

      Dir["#{EthilVan::Emoji.images_path}/*.png"].each do |file|
         FileUtils.rm_rf(file)
      end

      Dir["#{::Emoji.images_path}/emoji/*.png"].each do |src|
         basename = File.basename src, ".png"
         if blacklist.any? { |regexp| basename =~ regexp }
            next
         end

         filename = basename
         for filter in FILENAME_FILTERS
            filename = filename.gsub(*filter)
         end

         FileUtils.cp(src,
               File.join(EthilVan::Emoji.images_path, filename + ".png"))
      end
   end
end
