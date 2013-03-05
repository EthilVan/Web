module EthilVan::App::Views

   module Member::Activity

      class Account < ActivityPartial

         VOWELS = [?A, ?a, ?E, ?e, ?I, ?i, ?O, ?o, ?U, ?u]

         def subject
            _subject.name
         end

         def subject_url
            urls.profil(_subject)
         end

         def subject_avatar
            _subject.profil.avatar_url
         end

         def subject_is_viewer?
            current? _subject
         end

         def subject_old_role
            _subject_old_role
         end

         def subject_old_role_vowel?
            VOWELS.include? _subject_old_role[0]
         end

         def subject_new_role
            _subject_new_role
         end

         def subject_new_role_vowel?
            VOWELS.include? _subject_new_role[0]
         end

         def _subject_old_role
            @old_role ||= EthilVan::Role.get(_roles[0].to_sym).name
         end

         def _subject_new_role
            @new_role ||= EthilVan::Role.get(_roles[1].to_sym).name
         end

         def _roles
            @roles = @model.data.split(',')
         end
      end
   end
end
