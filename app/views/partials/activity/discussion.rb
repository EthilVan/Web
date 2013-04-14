module EthilVan::App::Views

   module Member::Activity

      class Discussion < ActivityPartial

         def discussion_urls
            @discussion_urls ||= begin
               if _subject.group.is_a? GestionDiscussionGroup
                  urls::Gestion
               else
                  urls::Member
               end
            end
         end

         def subject_url
            discussion_urls::Discussion.show(_subject)
         end

         def subject
            _subject.name
         end

         def subject_group
            _subject.group.name
         end

         def subject_group_url
            discussion_urls::DiscussionGroup.show(_subject.group)
         end

         def subject_moved_from
            _subject_moved_from.name
         end

         def subject_moved_from_url
            discussion_urls::DiscussionGroup.show(_subject_moved_from)
         end

         def subject_moved_to
            _subject_moved_to.name
         end

         def subject_moved_to_url
            discussion_urls::DiscussionGroup.show(_subject_moved_to)
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
