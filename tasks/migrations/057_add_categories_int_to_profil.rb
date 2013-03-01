class AddCategoriesIntToProfil < ActiveRecord::Migration

   def self.up
      add_column :profils, :categories_int, :integer, default: 0
   end

   def self.down
      remove_column :profils, :categories_int
   end
end
