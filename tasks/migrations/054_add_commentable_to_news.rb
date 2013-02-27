class AddCommentableToNews < ActiveRecord::Migration

   def self.up
      add_column :newses, :commentable, :boolean, default: true
   end

   def self.down
      remove_column :newses, :commentable
   end
end
