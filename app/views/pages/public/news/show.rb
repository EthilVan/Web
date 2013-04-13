module EthilVan::App::Views

   module Public::News

      class Show < Page

         def initialize(news)
            @news = news
         end

         def meta_page_title
            "#{@news.title} | News"
         end

         def news
            NewsPartial.new(@news)
         end

         def commentable?
            @news.commentable?
         end

         def comment_url
            urls::Public::News::Comment.create(@news)
         end
      end
   end
end
