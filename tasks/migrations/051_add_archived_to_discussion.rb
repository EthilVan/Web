class AddArchivedToDiscussion < ActiveRecord::Migration

   def self.up
      add_column :discussions, :archived, :boolean, default: false
   end

   def self.down
      remove_column :discussions, :archived
   end
end
