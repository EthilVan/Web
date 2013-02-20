class EthilVan::App < Sinatra::Base

   error 401 do
      view Views::Error::NotAuthorized.new
      mustache 'error/not_authorized'
   end

   not_found do
      view Views::Error::NotFound.new
      mustache 'error/not_found'
   end

   error do
      view Views::Error::Default.new
      mustache 'error/default'
   end
end
