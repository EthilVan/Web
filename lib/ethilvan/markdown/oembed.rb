require 'oembed'

OEmbed::Providers.register_all(:aggregators)
OEmbed::Providers::Embedly.endpoint += '?key=8abb0b1d5f9a4c93910f0503fd2ca861'

module EthilVan::Markdown::Helpers

   class ToHTML < Redcarpet::Render::HTML

      OEMBED_CACHE = {}

      def image(link, title, alt)
         return OEMBED_CACHE[link] if OEMBED_CACHE.key?(link)
         res = OEmbed::Providers.get(link)
         OEMBED_CACHE[link] = res.html
      rescue
         img = "<img src=\"#{link}\""
         img << " alt=\"#{alt}\"" if alt
         img << " title=\"#{title}\"" if title
         img << "/>"
         img
      end
   end
end

EthilVan::Cron.task do
   EthilVan::Markdown::Helpers::ToHTML::OEMBED_CACHE.clear
end
