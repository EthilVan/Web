module EthilVan::App::Views

   module Gestion::Announce

      class Create < Page

         def initialize(announce)
            @form = Form.new(announce, '/gestion/annonce/creer')
         end

         def form
            @form
         end
      end
   end
end
