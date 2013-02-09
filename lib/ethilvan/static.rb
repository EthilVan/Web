module EthilVan::Static

   BLACKLIST = [
      'robots.txt',
      'markdown/emojis.json',
      'images/emoji/.+',
   ].map { |s| /^#{s}$/ }

   SOURCE_DIR = 'content/static'
   PRODUCTION_DIR = 'static'

   if EthilVan.production?
      STATIC_DIR = PRODUCTION_DIR
      git_ref     = `git rev-parse --short=12 HEAD`.strip
      BUSTER_DIR  = File.join(STATIC_DIR, git_ref)
      BASE_URL    = '/' + git_ref + '/'
   else
      STATIC_DIR = SOURCE_DIR
      BASE_URL    = '/'
   end

   def self.registered(app)
      app.set(:public_folder, STATIC_DIR)
      app.helpers Helpers
      EthilVan.production? do
         app.set(:static_cache_control, [])
         app.helpers CacheControl
      end
   end

   module Helpers

      extend self

      def static
         BASE_URL
      end

      def asset(path)
         BASE_URL + path
      end
   end

   module CacheControl

      EXPIRES_AMOUNT = 1.year.from_now

      def cache_control(*args)
         (@buster = false; return super(*args)) if @buster
         return super(*args) unless env['sinatra.static_file']
         return super(*args) unless request.path_info.start_with? BASE_URL
         @buster = true
         expires EXPIRES_AMOUNT
      end
   end
end
