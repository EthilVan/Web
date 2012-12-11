class EthilVan::App < Sinatra::Base

   name = '(.+)' # TODO: Replace with proper regexp
   scale = '(?:_x([1-8]))?'

   get %r{/skin/#{name}_preview#{scale}.png$} do |username, scale|
      expires 24.hours.to_i, :public
      account = Account.find_by_name username
      raise Sinatra::NotFound if account.nil?
      scale = scale.to_i unless scale.nil?
      send_file EthilVan::Skins.preview(account.minecraft_name, scale)
   end

   get %r{/skin/#{name}_head#{scale}.png$} do |username, scale|
      expires 24.hours.to_i, :public
      account = Account.find_by_name username
      raise Sinatra::NotFound if account.nil?
      scale = scale.to_i unless scale.nil?
      send_file EthilVan::Skins.head(account.minecraft_name, scale)
   end
end
