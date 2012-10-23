# Configuration de l'application
module EthilVan

   class App < Sinatra::Base
      set :environment, EthilVan::ENV
      set :root, EthilVan::ROOT

      register EthilVan::Mustache
      set :layout, "layouts/default"
   end
end

# Routes
rrequire_dir 'routes'
