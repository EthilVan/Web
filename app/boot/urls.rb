module EthilVan

   module RawUrls

      extend self

      def news(news_id)
         "/news/#{news_id}"
      end

      def profil(account_name)
         "/membre/@#{account_name}"
      end

      def skin_preview(account, scale)
         skin_url(account, 'preview', scale)
      end

      def skin_head(account, scale)
         skin_url(account, 'head', scale)
      end

      def discussion(discussion_id)
         "/membre/discussion/#{discussion_id}"
      end

      def discussion_group(dg_name)
         "/membre/discussion/#{dg_name}"
      end

   private

      def skin_url(account, type, scale = nil)
         url = "/membre/skin/#{account}_#{type}"
         url << scale unless scale.nil?
         url << '.png'
         url
      end
   end

   module Urls

      include RawUrls
      extend self

      def news(news)
         super news.id
      end

      def profil(account)
         super account.name
      end

      def skin_preview(account, scale)
         super(account.name, scale)
      end

      def skin_head(account, scale)
         super(account.name, scale)
      end

      def discussion(discussion)
         super discussion.id
      end

      def discussion_group(dg)
         super dg.url
      end
   end

   module UrlsDefinition

      extend self

      def respond_to?(method)
         RawUrls.respond_to? method
      end

      def method_missing(name, *args)
         url = RawUrls.send(name, *args)
         /#{url}$/
      end
   end

   module Urls::Sinatra

      def self.registered(app)
         app.helpers Helpers
         app.extend ClassHelpers
      end

      module Helpers

         def urls
            Urls
         end
      end

      module ClassHelpers

         def urls
            UrlsDefinition
         end
      end
   end
end
