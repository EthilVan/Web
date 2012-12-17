require_relative 'env'
require_relative 'database'

# Configuration de l'application
module EthilVan

   class App < Sinatra::Base
      set :environment, EthilVan::ENV
      set :root, EthilVan::ROOT
      set :public_folder, 'static'
      set :session_secret,
            'FDzUODfLBuvgoPpb7ZVIDAcfOoMMsoyW6u_ob-VRirVBBZ7xvoYj5l0DO7bOyyNJ'
      enable :sessions

      EthilVan.development? do
         require 'better_errors'
         use BetterErrors::Middleware
         BetterErrors.application_root = EthilVan::ROOT

         require 'rack-mini-profiler'
         use Rack::MiniProfiler

         require 'sinatra/reloader'
         register Sinatra::Reloader
         also_reload 'lib/**/*'
         also_reload 'app/**/*'
      end

      register EthilVan::Mustache
      set :layout, 'layouts/default'

      register EthilVan::Authentication
      set :remember_for, 2.months

      register EthilVan::Authorization
      logged_only %r{^/membre}
      logged_only %r{^/markdown$}
      protect %r{^/news/creer}, EthilVan::Role::REDACTEUR
      protect %r{^/moderation}, EthilVan::Role::MODO

      register EthilVan::Markdown
   end
end

require_all 'app/views'
require_all 'app/controllers'
