class DiscussionView < ActiveRecord::Base

   belongs_to :account
   belongs_to :discussion

   def self.mark_all_read_for(account)
      where(account_id: account.id).destroy_all
      create(account_id: account.id, discussion_id: nil, date: Time.now)
   end

   def self.update_for(account, discussion, date = Time.now)
      view = where(account_id: account.id, discussion_id: discussion.id).first
      if view.nil?
         view = DiscussionView.create(account_id: account.id,
               discussion_id: discussion.id, date: date)
      else
         view.update_attribute :date, date
      end
   end

   def self.date_for(account, discussion)
      where(account_id: account.id, discussion_id: [nil, discussion.id]).
            maximum(:date)
   end
end
