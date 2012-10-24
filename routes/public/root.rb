class EthilVan::App < Sinatra::Base

   get '/' do
      redirect '/presentation/generale'
   end
end
