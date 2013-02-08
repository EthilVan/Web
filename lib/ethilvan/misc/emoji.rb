module EthilVan::Emoji

   DIRECTORIES = ['images', 'emoji']

   def self.json_path
      File.join(EthilVan::Static::SOURCE_DIR, 'markdown', 'emojis.json')
   end

   def self.source_path
      File.join(EthilVan::Static::SOURCE_DIR, *DIRECTORIES)
   end

   def self.images_path
      File.join(EthilVan::Static::STATIC_DIR, *DIRECTORIES)
   end

   def self.names
      @names ||= Dir["#{images_path}/*.png"].map do |fn|
         File.basename(fn, '.png')
      end.sort
   end
end
