class DiscussionViews

   def initialize(group_type, account)
      @group_type = group_type
      arel_discussion_id = DiscussionView.arel_table[:discussion_id]
      condition = arel_discussion_id.eq(group_type::ALL_READ_ID)
            .or(arel_discussion_id.gteq(0))
      @views = account.discussion_views.where(condition)
         .group_by { |view| view.discussion_id }
   end

   def include?(discussion)
      view = @views[@group_type::ALL_READ_ID]
      return true if !view.nil? and view.first > discussion
      view = @views[discussion.id]
      return (!view.nil? and view.first > discussion)
   end
end
