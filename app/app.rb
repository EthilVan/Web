require_relative 'env'

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
         also_reload "app/helpers/**/*"
         also_reload "app/views/**/*"
      end

      register EthilVan::Mustache
      set :layout, "layouts/default"

      register EthilVan::Authentication
      set :remember_for, 2.months

      register EthilVan::Authorization
      logged_only %r{^/membre}
      protect %r{^/news/creer}, EthilVan::Role::REDACTEUR
      protect %r{^/moderation}, EthilVan::Role::MODO

      register EthilVan::Markdown

      # Routes
      rrequire_rdir 'app/controllers'
   end
end