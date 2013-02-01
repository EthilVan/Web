require_relative 'env'
require_relative 'mail'
require_relative 'database'

# Configuration de l'application
module EthilVan

   class App < Sinatra::Base
      set :environment, EthilVan::ENV
      set :root, EthilVan::ROOT
      set :public_folder, 'static'

      register EthilVan::Logging

      enable :sessions
      set :session_secret,
            'FDzUODfLBuvgoPpb7ZVIDAcfOoMMsoyW6u_ob-VRirVBBZ7xvoYj5l0DO7bOyyNJ'

      EthilVan.development? do
         before { I18n.reload! }

         #require 'better_errors'
         #use BetterErrors::Middleware
         #BetterErrors.application_root = EthilVan::ROOT

         require 'rack-mini-profiler'
         Rack::MiniProfiler.config.position = 'right'
         use Rack::MiniProfiler

         require 'sinatra/reloader'
         register Sinatra::Reloader
         also_reload 'lib/**/*'
         also_reload 'app/**/*'
      end

      register EthilVan::Urls::Sinatra

      register EthilVan::Mail

      register EthilVan::Mustache
      set :layout, 'layouts/default'

      register EthilVan::Authentication
      set :remember_for, 2.months

      register EthilVan::Authorization

      register EthilVan::Markdown
   end
end

require_all 'app/views'
require_all 'app/controllers'
