module EthilVan::App::Views

   module Member::Activity

      class Message < ActivityPartial

         def discussion_urls
            @discussion_urls ||= begin
               if _subject.discussion.group.is_a? GestionDiscussionGroup
                  urls::Gestion
               else
                  urls::Member
               end
            end
         end

         def subject_url
            discussion_urls::Message.show(_subject)
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
            urls::Member::Profil.show(_subject.account)
         end
      end
   end
end
