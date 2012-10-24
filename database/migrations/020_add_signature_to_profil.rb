class AddSignatureToProfil < ActiveRecord::Migration

   def self.up
      add_column :profils, :signature, :text
   end

   def self.down
      remove_column :profils, :signature
   end
end
