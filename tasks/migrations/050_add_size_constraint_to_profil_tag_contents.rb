class AddSizeConstraintToProfilTagContents < ActiveRecord::Migration

   def self.up
      remove_column :profil_tags, :contents
      add_column    :profil_tags, :content, :text, limit: 300
   end

   def self.down
      remove_column :profil_tags, :content
      add_column    :profil_tags, :contents, :text
   end
end
