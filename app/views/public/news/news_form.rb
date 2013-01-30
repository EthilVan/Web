module EthilVan::App::Views

   module Public::News

      class NewsForm < Page

         include EthilVan::Mustache::Form

         def initialize(news)
            @news = news
         end

         def errors?
            not @news.errors.empty?
         end

         def errors
            @news.errors.to_a
         end

         def news_title
            @news.title
         end

         def banner
            @news.banner
         end

         def summary
            @news.summary
         end

         def contents
            @news.contents
         end

         def private
            checkbox @news.private
         end

         def important
            checkbox @news.important
         end
      end
   end
end
