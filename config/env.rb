module EthilVan

   ENV = (::ENV["RACK_ENV"] || "development").to_sym
   ROOT = File.expand_path('../..', __FILE__)

end

require 'bundler'
Bundler.require(:default, EthilVan::ENV)

# Lib & helpers
require './lib/core/require'
rrequire_rdir 'lib'

# Base de données
rrequire 'config/database'
rrequire_dir 'database/models'

# Routes
rrequire_dir 'routes'
