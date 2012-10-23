module EthilVan

   class App < Sinatra::Base
      get '/' do
         view Views::Public::Presentation::Generale.new
         mustache "public/presentation/generale"
      end
   end
end
