class CreateGeneralDiscussionGroupSubscriptions < ActiveRecord::Migration

   def self.up
      create_table :general_discussion_group_subscriptions do |t|
         t.integer :general_discussion_group_id
         t.integer :account_id
      end
   end

   def self.down
      drop_table :general_discussion_group_subscriptions
   end
end
