module EthilVan::App::Views

   module Member::Activity

      class Account < ActivityPartial

         def subject
            _subject.name
         end

         def subject_url
            urls.profil(_subject)
         end

         def subject_is_viewer?
            current? _subject
         end
      end
   end
end
