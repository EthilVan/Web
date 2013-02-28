class CreateActivities < ActiveRecord::Migration

   def self.up
      create_table :activities do |t|
         t.integer    :subject_id
         t.string     :subject_type
         t.string     :action, limit: 20
         t.integer    :actor_id
         t.timestamp  :created_at

         t.text       :data
      end
   end

   def self.down
      drop_table :activities
   end
end
