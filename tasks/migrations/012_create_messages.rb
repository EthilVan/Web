class CreateMessages < ActiveRecord::Migration

   def self.up
      create_table :messages do |t|
         t.integer :account_id
         t.integer :discussion_id
         t.text :contents
      end
   end

   def self.down
      drop_table :messages
   end
end
