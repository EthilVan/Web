# Configuration de l'application
module EthilVan

   class App < Sinatra::Base
      set :environment, EthilVan::ENV
      set :root, EthilVan::ROOT

      register EthilVan::Mustache
      set :layout, "layouts/default"

      register EthilVan::Authentication
      set :remember_for, 2.months
   end
end

# Routes
rrequire_rdir 'app/controllers'
