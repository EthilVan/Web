module EthilVan::App::Views

   module Gestion::Postulation

      class VoteForm < EthilVan::Mustache::Form

         def initialize(vote)
            super(vote)
         end

         def agreement
            boolean :agreement
         end

         def message
            text :message
         end
      end
   end
end
