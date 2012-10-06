module EthilVan

   ENV = (::ENV["RACK_ENV"] || "development").to_sym
   ROOT = File.expand_path('../..', __FILE__)

end

require 'bundler'
Bundler.require(:default, EthilVan::ENV)

# Lib & helpers
require './lib/core/require'
rrequire_all 'lib'

# Base de données
rrequire 'config/database'
rrequire_dir 'database/models'
