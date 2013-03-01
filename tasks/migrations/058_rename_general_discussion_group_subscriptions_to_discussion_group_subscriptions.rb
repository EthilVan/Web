class RenameGeneralDiscussionGroupSubscriptionsToDiscussionGroupSubscriptions < ActiveRecord::Migration

   def self.up
      rename_table :general_discussion_group_subscriptions, :discussion_group_subscriptions
      rename_column :discussion_group_subscriptions, :general_discussion_group_id, :group_id
   end

   def self.down
      rename_table :discussion_group_subscriptions, :general_discussion_group_subscriptions
      rename_column :general_discussion_group_subscriptions, :group_id, :general_discussion_group_id
   end
end
