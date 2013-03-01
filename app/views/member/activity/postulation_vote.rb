module EthilVan::App::Views

   module Member::Activity

      class PostulationVote < ActivityPartial

         def subject_postulation
            _subject.postulation.name
         end

         def subject_postulation_url
            "/gestion/postulation/#{_subject.postulation.name}"
         end
      end
   end
end
