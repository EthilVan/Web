module EthilVan

   module Url::Public

      module News

         extend self

         BASE = '/news'

         def list
            BASE
         end

         def feed
            BASE + '/feed'
         end

         def launcher
            BASE + '/launcher'
         end

         def images
            BASE + '/images'
         end

         def create
            BASE + '/creer'
         end

         def base(news)
            "#{BASE}/#{news.id}"
         end

         def show(news)
            base(news)
         end

         def edit(news)
            base(news) + '/editer'
         end

         def delete(news)
            base(news) + '/supprimer'
         end
      end
   end
end
