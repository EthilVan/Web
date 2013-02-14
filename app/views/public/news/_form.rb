module EthilVan::App::Views

   module Public::News

      class Form < EthilVan::Mustache::Form

         def initialize(news)
            super(news)
         end

         def news_title
            text :title, validations: {
               required: true,
            }
         end

         def banner
            text :banner, validations: {
               type: 'urlstrict'
            }
         end

         def summary
            markdown :summary, validations: {
               required: true,
            }
         end

         def contents
            markdown :contents, validations: {
               required: true,
            }
         end

         def private
            switch_f :private
         end

         def important
            switch_f :important
         end
      end
   end
end
