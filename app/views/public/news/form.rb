module EthilVan::App::Views

   module Public::News

      class Form < EthilVan::Mustache::ModelForm

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
            text :summary, validations: {
               required: true,
            }
         end

         def contents
            text :contents, validations: {
               required: true,
            }
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
