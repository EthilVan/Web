Encoding.default_internal = "UTF-8"
Encoding.default_external = "UTF-8"

module EthilVan

   ENV = (::ENV["RACK_ENV"] || "development").to_sym
   ROOT = File.expand_path('../..', __FILE__)

   def self.development?
      ENV == :development
   end

   def self.production?
      ENV == :production
   end
end

require 'bundler'
Bundler.setup(:default, EthilVan::ENV)

# Ensure this is loaded now
require 'active_support/time'

# Lib & helpers
require './lib/core/require'
rrequire_rdir 'lib/core'
rrequire_rdir 'lib/mustache'
rrequire_rdir 'lib/authorization'
rrequire_rdir 'lib/misc'
rrequire 'lib/skins/skins'

# Base de données
rrequire 'config/database'
rrequire_dir 'database/models'
