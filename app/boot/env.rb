Encoding.default_internal = "UTF-8"
Encoding.default_external = "UTF-8"

module EthilVan

   extend self

   ENV = (::ENV["RACK_ENV"] || "development").to_sym
   ROOT = File.expand_path('../../..', __FILE__)

   def path(*args)
      File.join(ROOT, *args)
   end

   def glob(*args)
      Dir[path(*args)]
   end

   def expand_path(path)
      File.expand_path(path, ROOT)
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

   if production?
      VERSION = 'v' + `git describe --tags --abbrev=0`.strip
   else
      VERSION = "Dev"
   end

   require_relative 'config'
   Config = YamlConfig.new path('config.yml')

   require 'bundler'
   Bundler.setup(:default, EthilVan::ENV)

   require 'i18n'
   I18n.load_path += glob('content/data/locales/**/*.yml')
   I18n.default_locale = 'fr'

   $LOAD_PATH.unshift path('lib')
   require 'ethilvan'

   require_all 'app/jobs'
end
