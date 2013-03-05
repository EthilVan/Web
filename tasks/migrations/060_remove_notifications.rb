class RemoveNotifications < ActiveRecord::Migration

   def self.up
      drop_table :notifications
   end

   def self.down
      create_table :notifications do |t|
         t.integer :account_id
         t.integer :type
         t.integer :type_id
         t.timestamp :created_at
      end
   end
end
