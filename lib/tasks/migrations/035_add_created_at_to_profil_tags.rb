class AddCreatedAtToProfilTags < ActiveRecord::Migration

   def self.up
      add_column :profil_tags, :created_at, :timestamp
   end

   def self.down
      remove_column :profil_tags, :created_at
   end
end
