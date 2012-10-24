class AddUrlToGeneralDiscussionGroup < ActiveRecord::Migration

   def self.up
      add_column :general_discussion_groups, :url, :string
   end

   def self.down
      remove_column :general_discussion_groups, :url
   end
end
