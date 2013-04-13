module EthilVan

   module Url::Gestion

      module Postulation

         extend self

         BASE = '/gestion/postulation'

         def list
            BASE
         end

         def base(postulation)
            "#{BASE}/#{postulation.name}"
         end

         def show(postulation)
            base(postulation)
         end
      end
   end
end
