class CreateDiscussionView < ActiveRecord::Migration

   def self.up
      create_table :discussion_views do |t|
         t.integer :discussion_id
         t.integer :account_id
         t.timestamp :date
      end
   end

   def self.down
      drop_table :discussion_views
   end
end
