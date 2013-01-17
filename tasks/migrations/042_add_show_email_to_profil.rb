class AddShowEmailToProfil < ActiveRecord::Migration

   def self.up
      add_column(:profils, :show_email, :boolean, default: false)
   end

   def self.down
      remove_column(:profils, :show_email)
   end
end
