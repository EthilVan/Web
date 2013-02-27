class AddCategoriesIntToNewses < ActiveRecord::Migration

   def self.up
      remove_column :newses, :important
      add_column :newses, :categories_int, :integer, default: 1
   end

   def self.down
      add_column :newses, :important, :boolean
      remove_column :newses, :categories_int
   end
end
