module EthilVan::App::Views

   module Gestion::Postulation

      class Show < Page

         def initialize(postulation)
            @postulation = postulation
         end

         def meta_page_title
            "#{name} | Postulation | EthilVan"
         end

         def page_title
            "Postulation - #{name}"
         end

         def name
            @postulation.name
         end

         def age
            time = Time.now - @postulation.birthdate.to_time
            Time.at(time).year - 1970
         end

         presence_predicate :birthdate
         def birthdate
            @postulation.birthdate.strftime(EthilVan::Data::DATE_FORMAT)
         end

         presence_predicate :sexe
         def sexe
            # ::Postulation::Sexe.find { |s| s[1] == @postulation.sexe }[0]
            @postulation.sexe
         end

         def minecraft_since
            @postulation.minecraft_since
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

         def microphone?
            @postulation.microphone
         end

         def microphone
            microphone? ? 'Oui' : 'Non'
         end

         def mumble
            return @postulation.mumble_other if @postulation.mumble == 'Autre'
            @postulation.mumble
         end

         def free_text
            @postulation.free_text
         end

         presence_predicate :agreements
         def agreements_number
            agreements.size
         end

         def agreements
            @agreements ||= @postulation.agreements.map { |a| a.account }
         end

         def pending?
            @postulation.status == 0
         end

         def can_vote?
            PostulationVote.where(
               postulation_id: @postulation.id,
               account_id: current_account.id,
            ).empty?
         end
      end
   end
end
