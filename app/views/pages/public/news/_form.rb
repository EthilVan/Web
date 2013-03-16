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
            boolean :private
         end

         def important
            boolean :important
         end

         def commentable
            boolean :commentable
         end

         def categories
            categories = NewsCategories.names
                  .each_with_object({}) do |category, h|
               h[category] = EthilVan::Data::News::Categories[category.to_s]
            end
            multichoice :categories, among: categories
         end
      end
   end
end
