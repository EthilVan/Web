class EthilVan::App < Sinatra::Base

   # Public avatar
   get %r{/avatar/(#{Account::NAME}).png$} do |username|
      skin_image EthilVan::Skins::Head, username, 15
   end

   scale = '(?:_x([1-8]))?'

   helpers do

      def skin_image(type, name, scale)
         expires 4.hours.to_i, :public
         content_type 'image/png'
         minecraft_name = resource Account.where(name: name)
               .pluck(:minecraft_name).first
         scale = (scale || 1).to_i
         send_file type.new(minecraft_name, scale).get
      end
   end

   preview = %r{/membre/skin/(#{Account::NAME})_preview#{scale}.png$}
   get preview do |username, scale|
      skin_image EthilVan::Skins::Preview, username, scale
   end

   head = %r{/membre/skin/(#{Account::NAME})_head#{scale}.png$}
   get head do |username, scale|
      skin_image EthilVan::Skins::Head, username, scale
   end
end
