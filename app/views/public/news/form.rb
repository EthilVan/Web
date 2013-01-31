module EthilVan::App::Views

   module Public::News

      class Form < EthilVan::Mustache::ModelForm

         def initialize(news)
            super(news)
         end

         def news_title
            text :title
         end

         def banner
            text :banner
         end

         def summary
            text :summary
         end

         def contents
            text :contents
         end

         def private
            checkbox :private
         end

         def important
            checkbox :important
         end
      end
   end
end
