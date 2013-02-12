require 'oembed'

OEmbed::Providers.register_all(:aggregators)
OEmbed::Providers::Embedly.endpoint += '?key=8abb0b1d5f9a4c93910f0503fd2ca861'

module EthilVan::Markdown::Helpers

   module OEmbed

      CACHE = {}
      EthilVan::Cron.task { CACHE.clear }

      def image(link, title, alt)
         return CACHE[link] if CACHE.key?(link)
         res = ::OEmbed::Providers.get(link)
         CACHE[link] = res.html
      rescue
         super(link, title, alt)
      end
   end

   class ToHTML
      override_image
      include OEmbed
   end

end
