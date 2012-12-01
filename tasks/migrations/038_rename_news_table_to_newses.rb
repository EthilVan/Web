class RenameNewsTableToNewses < ActiveRecord::Migration

   def self.up
      rename_table :news, :newses
   end

   def self.down
      rename_table :newses, :news
   end
end
