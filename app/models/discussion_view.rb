class DiscussionView < ActiveRecord::Base

   include Comparable

   belongs_to :account
   belongs_to :discussion

   def self.mark_all_read_for(group, account)
      discussion_ids = Discussion
            .where(discussion_group_type: group.name).pluck(:id)
      discussion_ids.unshift(group::ALL_READ_ID)
      where(account_id: account.id, discussion_id: discussion_ids).destroy_all
      create(account_id: account.id,
            discussion_id: group::ALL_READ_ID, date: Time.now)
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
