Encoding.default_internal = "UTF-8"
Encoding.default_external = "UTF-8"

module EthilVan

   extend self

   ENV = (::ENV["RACK_ENV"] || "development").to_sym
   ROOT = File.expand_path('../..', __FILE__)

   def path(*args)
      File.join(ROOT, *args)
   end

   def glob(*args)
      Dir[path(*args)]
   end

   def development?(&block)
      env :development, &block
   end

   def production?(&block)
      env :production, &block
   end

   def test?(&block)
      env :test, &block
   end

   def env(name)
      bool = name == ENV
      yield if bool and block_given?
      bool
   end

   require 'yaml'
   Config = YAML.load_file 'config.yml'

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
   rrequire 'lib/markdown/markdown'
   rrequire 'lib/skins/skins'

   # Base de données
   require_relative 'database'
   rrequire_dir 'database/models'
end
