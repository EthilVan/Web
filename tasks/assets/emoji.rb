require 'emoji'

module EthilVan::Emoji

   BLACKLIST = [
      'ant',
      'arrows_clockwise',
      'clock.+',
      'copyright',
      'curly_loop',
      'currency_exchange',
      'end',
      'heavy_.+',
      'musical_score',
      'notes',
      'on',
      'registered',
      'soon',
      'tm',
      'wavy_dash',
      'u[567].+',
   ].map do |pattern|
      /^#{pattern}$/
   end

   FILENAME_FILTERS = {
      '+' => 'plus',
   }

   def self.install
      Dir["#{EthilVan::Emoji.images_path}/*.png"].each do |file|
         FileUtils.rm_rf(file)
      end

      Dir["#{::Emoji.images_path}/emoji/*.png"].each do |src|
         basename = File.basename src, '.png'
         next if BLACKLIST.any? { |regexp| basename =~ regexp }

         filename = basename
         FILENAME_FILTERS.each do |key, value|
            filename = filename.gsub(key, value)
         end

         dest = File.join(images_path, filename + '.png')
         FileUtils.cp(src, dest)
      end
   end
end
