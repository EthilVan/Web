class AddIconToGeneralDiscussionGroup < ActiveRecord::Migration

   def self.up
      add_column(:general_discussion_groups, :icon, :string)
   end

   def self.down
      remove_column(:general_discussion_groups, :icon)
   end
end
