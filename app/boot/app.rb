require_relative 'env'
require_relative 'mail'
require_relative 'database'

# Configuration de l'application
module EthilVan

   class App < Sinatra::Base

      EthilVan.development? do
         before { I18n.reload! }
         before { Activity::Subject.reload! }

         require 'better_errors'
         use BetterErrors::Middleware
         BetterErrors.application_root = EthilVan::ROOT
         BetterErrors.editor = :sublime
         enable :sessions
         set :raise_errors, true

         require 'rack-mini-profiler'
         Rack::MiniProfiler.config.position = 'right'
         use Rack::MiniProfiler

         require 'sinatra/reloader'
         register Sinatra::Reloader
         also_reload 'lib/**/*'
         also_reload 'app/**/*'
      end

      register EthilVan::SinatraHelpers
      register EthilVan::Logging
      register EthilVan::Cron::Sinatra
      register EthilVan::Static
      register EthilVan::Urls::Sinatra
      register EthilVan::Cookies
      register EthilVan::Authentication
      register EthilVan::Authorization
      register EthilVan::Mustache
      register EthilVan::Markdown
      register EthilVan::Mail

      set :environment,         EthilVan::ENV
      set :root,                EthilVan::ROOT
      set :show_exceptions,     false
      set :pseudo_cookie_name,  'CYd1Zj6wab9ff1K8gbWNu4cJLQtjqg5MJgGbCI'
      set :token_cookie_name,   'IZq3tuP6qQbHwflEXoLByl3sJGZ2n4tjMdWZA5'
      set :remember_for,        2.months
      set :layout,              'layouts/default'
      set :mustache_templates,  'content/templates{,/partials}'
   end
end

require_all 'app/views'
require_all 'app/controllers'
