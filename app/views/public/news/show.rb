module EthilVan::App::Views

   module Public::News

      class Show < Page

         def initialize(news)
            @news = news
         end

         def news
            NewsPartial.new(@news)
         end
      end
   end
end
