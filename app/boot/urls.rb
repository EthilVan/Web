module EthilVan

   module RawUrls

      extend self

      def news(news_id)
         "/news/#{news_id}"
      end

      def profil(page = nil, account_name)
         url = "/membre/@#{account_name}"
         url << '/' << page unless page.nil?
         url
      end

      def skin_preview(account, scale)
         skin_url(account, 'preview', scale)
      end

      def skin_head(account, scale)
         skin_url(account, 'head', scale)
      end

      def discussion(discussion_id, page = nil, message = nil)
         url = "/membre/discussion/#{discussion_id}"
         url << "?page=#{page}" if page
         url << "#msg#{message}" if message
         url
      end

      def discussion_group(dg_name)
         "/membre/discussion/#{dg_name}"
      end

   private

      def skin_url(account, type, scale = nil)
         url = "/membre/skin/#{account}_#{type}"
         url << "_x#{scale}" unless scale.nil?
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

      def profil(page = nil, account)
         super(page, account.name)
      end

      def skin_preview(account, scale)
         super(account.name, scale)
      end

      def skin_head(account, scale)
         super(account.name, scale)
      end

      def discussion(discussion, page = nil, message = nil)
         super(discussion.id, page, message.nil? ? nil : message.id)
      end

      def discussion_group(dg)
         super dg.url
      end
   end

   module Urls::Sinatra

      def self.registered(app)
         app.helpers Helpers
      end

      module Helpers

         def raw_urls
            RawUrls
         end

         def urls
            Urls
         end
      end
   end
end
