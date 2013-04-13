module EthilVan::App::Views

   module Gestion::Announce

      class Created < Entry

         def initialize(announce)
            super(announce)
         end

         def create_url
            urls::Gestion::Announce.create
         end
      end
   end
end
