class EthilVan::App < Sinatra::Base

   name = '(.+)' # TODO: Replace with proper regexp
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

   get urls.skin_preview(name, scale) do |username, scale|
      skin_image EthilVan::Skins::Preview, username, scale
   end

   get urls.skin_head(name, scale) do |username, scale|
      skin_image EthilVan::Skins::Head, username, scale
   end
end
