class DiscussionView < ActiveRecord::Base

   include Comparable

   belongs_to :account
   belongs_to :discussion

   def self.mark_all_read_for(account)
      where(account_id: account.id).destroy_all
      create(account_id: account.id, discussion_id: nil, date: Time.now)
   end

   def self.update_for(account_id, discussion_id, date = Time.now)
      view = where(account_id: account_id, discussion_id: discussion_id).first
      unless view.nil?
         view.update_attribute :date, date
         return
      end
      DiscussionView.create(account_id: account_id,
            discussion_id: discussion_id, date: date)
   end

   def <=>(discussion)
      date.<=>(discussion.last_message.updated_at)
   end
end
