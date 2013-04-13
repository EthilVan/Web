module EthilVan::App::Views

   module Member::Activity

      class PostulationVote < ActivityPartial

         def subject_agreement?
            _subject.agreement?
         end

         def subject_refusal?
            not subject_agreement?
         end

         def subject_postulation
            _subject.postulation.name
         end

         def subject_postulation_url
            urls::Gestion::Postulation.show(_subject.postulation)
         end
      end
   end
end
