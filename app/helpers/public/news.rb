# encoding: utf-8

module EthilVan::App::Views

   module Public::News

      class NewsPartial < Partial

         def initialize(news)
            @news = news
         end

         def url
             "/news/#{@news.id}"
         end

         def title
             @news.title
         end

         def banner_url
             @news.banner
         end

         def author
             @news.account.name
         end

         def private
             @news.private
         end

         def important_class
             @news.important ? "important" : ""
         end

         def summary
             @news.parsed_summary
         end

         def contents
             @news.parsed_contents
         end

         def created
             @news.created_at.strftime("%d/%m/%Y à %H:%M")
         end
      end
   end
end
