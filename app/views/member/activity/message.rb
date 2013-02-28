module EthilVan::App::Views

   module Member::Activity

      class Message < ActivityPartial

         def subject_url
            "/membre/message/#{_subject.id}"
         end

         def subject_discussion
            _subject.discussion.name
         end
      end
   end
end
