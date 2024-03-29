module EthilVan::App::Views

   module Member::Activity

      class ProfilTag < ActivityPartial

         def subject_tagged
            _subject.tagged.name
         end

         def subject_tagged_url
            urls::Member::Profil.show(_subject.tagged)
         end
      end
   end
end
