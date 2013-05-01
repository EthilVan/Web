require 'oembed'

OEmbed::Providers.register_all(:aggregators)
OEmbed::Providers::Embedly.endpoint += '?key=8abb0b1d5f9a4c93910f0503fd2ca861'

module EthilVan::Markdown::Helpers

   module OEmbed

      def image(link, title, alt)
         res = ::OEmbed::Providers.get(link)
         res.html
      rescue
         super(link, title, alt)
      end
   end

   class ToHTML
      override_image
      include OEmbed
   end

end
