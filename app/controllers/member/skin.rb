class EthilVan::App < Sinatra::Base

   scale = '(?:_x([1-8]|15))?'

   helpers do

      def skin_image(type, username, scale)
         expires 6.hours.to_i, :public
         account = Account.find_by_name username
         raise Sinatra::NotFound if account.nil?
         scale = scale.to_i unless scale.nil?
         send_file type.get(account.minecraft_name, scale)
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
