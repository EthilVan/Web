# Configuration de l'application
module EthilVan

   class App < Sinatra::Base
      set :environment, EthilVan::ENV
      set :root, EthilVan::ROOT
      set :session_secret,
            'FDzUODfLBuvgoPpb7ZVIDAcfOoMMsoyW6u_ob-VRirVBBZ7xvoYj5l0DO7bOyyNJ'
      enable :sessions

      if EthilVan.development?
         require 'sinatra/reloader'
         register Sinatra::Reloader
         also_reload "lib/**/*"
         also_reload "database/**/*"
      end

      register EthilVan::Mustache
      set :layout, "layouts/default"

      register EthilVan::Authentication
      set :remember_for, 2.months

      register EthilVan::Authorization
      MODERATEUR_ROLE = EthilVan::Authorization::Role.get :modo
      REDACTEUR_ROLE = EthilVan::Authorization::Role.get :redacteur
      before do
         ensure_logged_in if request.path =~ %r{^/membre}
         ensure_authorized ORATEUR_ROLE if request.path =~ %r{^/news/creer}
         ensure_authorized MODERATEUR_ROLE if request.path =~ %r{^/moderation}
      end
   end
end

# Routes
rrequire_rdir 'app/controllers'
