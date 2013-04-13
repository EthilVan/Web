module EthilVan

   module Url::Public

      module News::Comment

         extend self

         BASE = '/news/commentaire'

         def create(news)
            News.base(news) + '/commenter'
         end

         def base(comment)
            "#{BASE}/#{comment.id}"
         end

         def edit(comment)
            base(comment) + '/editer'
         end

         def delete(comment)
            base(comment) + '/supprimer'
         end
      end
   end
end
