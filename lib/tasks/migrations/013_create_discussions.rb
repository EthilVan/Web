class CreateDiscussions < ActiveRecord::Migration

   def self.up
      create_table :discussions do |t|
         t.integer :discussion_group_id
         t.integer :discussion_group_type
      end
   end

   def self.down
      drop_table :discussions
   end
end
