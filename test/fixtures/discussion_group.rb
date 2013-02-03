FactoryGirl.define do

   factory :discussion_group, class: GeneralDiscussionGroup do

      ignore { discussion_count 3 }

      name 'DiscussionGroup'
      url 'discussion_group'
      description 'DiscussionGroup Test'

      discussions do
         FactoryGirl.build_list(:discussion, discussion_count)
      end
   end
end
