# Configuration de l'application
module EthilVan

   class App < Sinatra::Base
      register EthilVan::Mustache
      set :layout, "layouts/default"
   end
end

# Routes
rrequire_dir 'routes'
