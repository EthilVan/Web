class EthilVan::App < Sinatra::Base

   get '/' do
      redirect '/presentation/generale'
   end

   post '/markdown' do
      halt 401 unless logged_in?
      markdown params['content']
   end
end
