module EthilVan::App::Views

   module Gestion::Announce

      class List < Page

         def initialize(announces)
            @announces = announces
         end

         def create_url
            urls::Gestion::Announce.create
         end

         def announces
            @announces.map do |announces|
               Entry.new(announces)
            end
         end
      end
   end
end
