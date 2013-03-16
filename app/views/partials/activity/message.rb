module EthilVan::App::Views

   module Member::Activity

      class Message < ActivityPartial

         def subject_url
            "/membre/message/#{_subject.id}"
         end

         def subject_discussion
            _subject.discussion.name
         end

         def actor_is_author?
            @model.actor_id == _subject.account_id
         end

         def author_is_viewer?
            current?(_subject.account)
         end

         def viewer_is_thirdparty?
            not (actor_is_viewer? or author_is_viewer?)
         end

         def author
            _subject.account.name
         end

         def author_url
            urls.profil _subject.account
         end
      end
   end
end
