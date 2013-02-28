module EthilVan::App::Views

   module Member::Activity

      class Discussion < ActivityPartial

         def subject
            _subject.name
         end

         def subject_group
            _subject.group.name
         end

         def subject_group_url
            urls.discussion_group(_subject.group)
         end
      end
   end
end
