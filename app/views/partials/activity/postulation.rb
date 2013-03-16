module EthilVan::App::Views

   module Member::Activity

      class Postulation < ActivityPartial

         def subject
            _subject.name
         end

         def subject_url
            "/gestion/postulation/#{_subject.name}"
         end

         def subject_is_viewer?
            current_account.postulation.id == _subject.id
         end
      end
   end
end
