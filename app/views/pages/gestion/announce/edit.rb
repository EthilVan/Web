module EthilVan::App::Views

   module Gestion::Announce

      class Edit < Page

         def initialize(announce)
            @form = Form.new(announce,
                  urls::Gestion::Announce.edit(announce))
         end

         def form
            @form
         end
      end
   end
end
