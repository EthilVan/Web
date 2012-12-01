class CreatePostulations < ActiveRecord::Migration

   def self.up
      create_table :postulations do |t|
         t.string :name
         t.string :minecraft_name
         t.string :email
         t.string :crypted_password
         t.date :birthdate
         t.string :sexe
         t.string :minecraft_since
         t.boolean :multi_minecraft
         t.text :old_server
         t.text :old_server_reason
         t.text :ethilvan_discovered
         t.text :ethilvan_reason
         t.text :availability_schedule
         t.boolean :microphone
         t.string :mumble
         t.string :mumble_other
         t.text :free_text
         t.timestamp :created_at
      end
      add_index(
         :postulations,
         [:name, :minecraft_name, :email],
         :unique => true
      )
      create_table :postulation_screens do |t|
         t.integer :postulation_id
         t.string :url
         t.text :description
      end
   end

   def self.down
      drop_table :postulation
      drop_table :postulation_screens
   end
end
