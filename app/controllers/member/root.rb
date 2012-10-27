class EthilVan::App < Sinatra::Base

   get '/membre' do
      redirect '/membre/discussion'
   end
end
