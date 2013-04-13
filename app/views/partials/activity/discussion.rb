module EthilVan::App::Views

   module Member::Activity

      class Discussion < ActivityPartial

         def subject_url
            urls::Member::Discussion.show(_subject)
         end

         def subject
            _subject.name
         end

         def subject_group
            _subject.group.name
         end

         def subject_group_url
            urls::Member::DiscussionGroup.show(_subject.group)
         end

         def subject_moved_from
            _subject_moved_from.name
         end

         def subject_moved_from_url
            urls::Member::DiscussionGroup.show(_subject_moved_from)
         end

         def subject_moved_to
            _subject_moved_to.name
         end

         def subject_moved_to_url
            urls::Member::DiscussionGroup.show(_subject_moved_to)
         end

         def _subject_moved_from
            @moved_from ||= GeneralDiscussionGroup.find_by_id(_data[0])
         end

         def _subject_moved_to
            @moved_to ||= GeneralDiscussionGroup.find_by_id(_data[1])
         end

         def _data
            @data ||= @model.data.split(",")
         end
      end
   end
end
