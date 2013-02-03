module EthilVan::App::Views

   module Member::Profil

      class Postulation < Partial

         def initialize(postulation)
            @postulation = postulation
         end

         def multi_minecraft?
            @postulation.multi_minecraft
         end

         def multi_minecraft
            multi_minecraft? ? "Oui" : "Non"
         end

         def old_server
            @postulation.old_server
         end

         def old_server_reason
            @postulation.old_server_reason
         end

         def ethilvan_discovered
            @postulation.ethilvan_discovered
         end

         def ethilvan_reason
            @postulation.ethilvan_reason
         end

         def screens
            @postulation.screens.map { |s| {
               url: s.url,
               description: s.description,
               width: s.width,
               height: s.height,
            } }
         end

         def availability
             @postulation.availability_schedule
         end

         def microphone
             @postulation.microphone
         end

         def mumble
             @postulation.mumble_other if @postulation.mumble == "Autre"
             @postulation.mumble
         end

         def free_text
             @postulation.free_text
         end
      end
   end
end
