class EthilVan::App < Sinatra::Base

   get '/' do
      redirect '/presentation/generale'
   end

   post '/markdown' do
      markdown params['content']
   end
end
