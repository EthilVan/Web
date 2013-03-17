class CreateGestionDiscussionGroups < ActiveRecord::Migration

   def self.up
      create_table :gestion_discussion_groups do |t|
         t.string    :name
         t.string    :url
         t.string    :role
         t.integer   :priority, default: 30
         t.string    :icon
         t.text      :description
      end
   end

   def self.down
      drop_table :gestion_discussion_groups
   end
end
