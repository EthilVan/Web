class DiscussionGroupSubscription < ActiveRecord::Base

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account
   belongs_to :group, class_name: 'GeneralDiscussionGroup'

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def self.create_for(account, group)
      query = where(account_id: account.id,
            group_id: group.id)
      if query.count == 0
         subscription = new
         subscription.account_id = account.id
         subscription.group_id   = group.id
         subscription.save
      end
   end

   def self.destroy_for(account, group)
      where(account_id: account.id,
            group_id: group.id).destroy_all
   end
end
