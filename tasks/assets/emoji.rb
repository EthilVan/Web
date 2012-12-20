require 'emoji'

module EthilVan::Emoji

   BLACKLIST = [
      'ant',
      'arrows_clockwise',
      'back',
      'black_[^j].*',
      'clock.+',
      'copyright',
      'curly_loop',
      'currency_exchange',
      'electric_plug',
      'end',
      'heavy_.+',
      'microphone',
      'movie_camera',
      'musical_score',
      'notes',
      'on',
      'poop',
      'registered',
      'shit',
      'soon',
      'tophat',
      'tm',
      'video_game',
      'water_buffalo',
      'wavy_dash',
      'u[567].+',
   ].map do |pattern|
      /^#{pattern}$/
   end

   FILENAME_FILTERS = {
      '+' => 'plus',
   }

   def self.install
      Dir["#{::Emoji.images_path}/emoji/*.png"].each do |src|
         basename = File.basename src, '.png'
         next if BLACKLIST.any? { |regexp| basename =~ regexp }

         filename = FILENAME_FILTERS.inject(basename) do |name, filter|
            name.gsub(*filter)
         end

         dest = File.join(images_path, filename + '.png')
         FileUtils.cp(src, dest)
      end
   end
end
