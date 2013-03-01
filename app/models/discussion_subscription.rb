class DiscussionSubscription < ActiveRecord::Base

   def self.create_for(account, discussion)
      query = where(account_id: account.id,
            discussion_id: discussion.id)
      if query.count == 0
         subscription = new
         subscription.account_id    = account.id
         subscription.discussion_id = discussion.id
         subscription.save
      end
   end

   def self.destroy_for(account, discussion)
      where(account_id: account.id,
            discussion_id: discussion.id).destroy_all
   end
end
