class CreateMessageMentions < ActiveRecord::Migration

   def self.up
      create_table :message_mentions do |t|
         t.integer :message_id
         t.integer :mentionner_id
         t.integer :mentionned_id
      end
   end

   def self.down
      drop_table :message_mentions
   end
end
