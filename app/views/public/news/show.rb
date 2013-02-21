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

         def comment_url
            "/news/#{@news.id}/commenter"
         end
      end
   end
end
