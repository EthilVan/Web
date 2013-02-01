class EthilVan::App < Sinatra::Base

   protect %r{^/gestion},    EthilVan::Role::MODO
   protect %r{^/moderation}, EthilVan::Role::MODO

   get '/gestion' do
      redirect '/gestion/postulation'
   end

   # Legacy
   get %r{/moderation(?:$|/)} do
      redirect request.path.gsub(%r{^/moderation}, '/gestion')
   end
end
