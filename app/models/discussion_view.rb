class DiscussionView < ActiveRecord::Base

   belongs_to :account
   belongs_to :discussion

   def self.for(account, discussion)
      where(account_id: account.id, discussion_id: discussion.id).first
   end
 end
