module EthilVan::Skins

   JavaFile = Java::JavaIo::File
   ImageIO = Java::JavaxImageio::ImageIO
   MinecraftSkin = Java::FrAumgnMinecraftskin::MinecraftSkin

   def self.generate_preview(username, scale, filename)
      skin = MinecraftSkin.fetch username
      save_image skin.preview(scale), filename
   end

   def self.generate_head(username, scale, filename)
      skin = MinecraftSkin.fetch username
      save_image skin.head_preview(scale), filename
   end

private

   def self.save_image(img, filename)
      file = JavaFile.new filename
      ImageIO.write(img, "png", file)
   end
end
