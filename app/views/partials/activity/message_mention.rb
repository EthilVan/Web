module EthilVan::App::Views

   module Member::Activity

      class MessageMention < ActivityPartial

         def subject_message_url
            "/membre/message/#{_subject.message.id}"
         end

         def subject_message_discussion
            _subject.message.discussion.name
         end

         def subject_mentionned_is_viewer?
            current? _subject.mentionned
         end

         def subject_mentionned_url
            "/membre/membre/@#{_subject.mentionned.name}"
         end

         def subject_mentionned
            _subject.mentionned.name
         end
      end
   end
end
