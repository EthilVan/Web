class CreateAnnounces < ActiveRecord::Migration

   def self.up
      create_table :announces do |t|
         t.integer    :account_id
         t.text       :content
         t.text       :parsed_content
         t.timestamp  :created_at
      end
   end

   def self.down
      drop_table :announces
   end
end
