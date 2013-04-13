module EthilVan::App::Views

   module Member::Activity

      class MessageMention < ActivityPartial

         def subject_message_url
            urls::Member::Message.show(_subject.message)
         end

         def subject_message_discussion
            _subject.message.discussion.name
         end

         def subject_mentionned_is_viewer?
            current? _subject.mentionned
         end

         def subject_mentionned_url
            urls::Member::Profil.show(_subject.mentionned)
         end

         def subject_mentionned
            _subject.mentionned.name
         end
      end
   end
end
