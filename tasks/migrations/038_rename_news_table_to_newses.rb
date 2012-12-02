class RenameNewsTableToNewses < ActiveRecord::Migration

   def self.up
      rename_table :news, :newses
      News.table_name = 'newses'
   end

   def self.down
      rename_table :newses, :news
      News.table_name = 'news'
   end
end
