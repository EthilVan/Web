class EthilVan::App < Sinatra::Base

   not_found do
      view Views::Error::NotFound.new
      mustache 'error/not_found'
   end

   error do
      view Views::Error::Default.new
      mustache 'error/default'
   end
end
