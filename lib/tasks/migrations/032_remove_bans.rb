class RemoveBans < ActiveRecord::Migration

   def self.up
      drop_table :bans
   end

   def self.down
      create_table :bans do |t|
         t.string :name
         t.string :minecraft_name
         t.string :email
         t.timestamp :created_at
      end
   end
end
