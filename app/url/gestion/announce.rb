module EthilVan

   module Url::Gestion

      module Announce

         extend self

         BASE = '/gestion/annonce'

         def list
            BASE
         end

         def create
            BASE + '/creer'
         end

         def base(announce)
            "#{BASE}/#{announce.id}"
         end

         def edit(announce)
            base(announce) + '/editer'
         end

         def delete(announce)
            base(announce) + '/supprimer'
         end
      end
   end
end
