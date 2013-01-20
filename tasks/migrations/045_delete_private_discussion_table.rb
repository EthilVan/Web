class DeletePrivateDiscussionTable < ActiveRecord::Migration

   def self.up
      drop_table :private_discussions
   end

   def self.down
      create_table :private_discussions do |t|
         t.integer :owner_id
         t.integer :receiver_id
      end
   end
end
