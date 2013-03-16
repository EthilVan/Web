module EthilVan::App::Views

   module Gestion::Announce

      class Edit < Page

         def initialize(announce)
            @form = Form.new(announce,
                  "/gestion/annonce/#{announce.id}/editer")
         end

         def form
            @form
         end
      end
   end
end
