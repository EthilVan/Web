class Discussion < ActiveRecord::Base

   has_many :messages
   belongs_to :group,
         polymorphic: true,
         foreign_key: 'discussion_group_id',
         foreign_type: 'discussion_group_type'
   has_many :discussion_subscriptions

   def read_by?(account)
      discussion_view = DiscussionView.for(account, self)
      !discussion_view.nil? and discussion_view.date > updated_at
   end
 end
