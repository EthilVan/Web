module EthilVan::Emoji

   def self.images_path
      File.join(EthilVan::ROOT, 'static', 'images', 'emoji')
   end

   def self.names
      @names ||= Dir["#{images_path}/*.png"].map do |fn|
         File.basename(fn, '.png')
      end.sort
   end
end
