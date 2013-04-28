class GeneralDiscussionGroup < ActiveRecord::Base

   include DiscussionGroup

   attr_accessible :name
   attr_accessible :url
   attr_accessible :icon
   attr_accessible :description
   attr_accessible :priority

   # ==========================================================================
   # * Relations
   # ==========================================================================
   has_many :discussion_group_subscriptions, foreign_key: :group_id
   has_many :subscribers, through: :discussion_group_subscriptions,
         source: :account

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def viewable_by?(account)
      true
   end

   def followed_by?(account)
      account.subscripted_group_ids.include? id
   end
end
