class EthilVan::App < Sinatra::Base

   logged_only %r{^/membre}

   get '/membre' do
      redirect '/membre/discussion'
   end
end
