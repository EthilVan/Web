class GeneralDiscussionGroup < ActiveRecord::Base

   has_many :discussions, as: :discussion_group, order: "updated_at DESC"

   def discussions_with_limit(limit)
      discussions_query.limit(5).order("updated_at DESC")
   end

   def discussions_count
      discussions_query.count
   end

private

   def discussions_query
      ::Discussion.where(discussion_group_id: id,
            discussion_group_type: self.class.name)
   end
end
