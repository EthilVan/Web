class UpdateDiscussionFirstLastMessageSystem < ActiveRecord::Migration

   def self.up
      add_column :messages, :first, :boolean, default: false
      add_column :messages, :last,  :boolean, default: false

      Message.reset_column_information
      Message.record_timestamps = false
      Message.all.each do |message|
         message.first = Discussion.where(first_message_id: message.id).count > 0
         message.last  = Discussion.where(last_message_id:  message.id).count > 0
         message.save validate: false
      end
      Message.record_timestamps = true

      remove_index :discussions, column: :first_message_id
      remove_index :discussions, column: :last_message_id
      remove_column :discussions, :first_message_id
      remove_column :discussions, :last_message_id
   end

   def self.down
      add_column :discussions, :first_message_id, :integer
      add_column :discussions, :last_message_id,  :integer
      add_index :discussions, :first_message_id, unique: true
      add_index :discussions, :last_message_id,  unique: true

      Discussion.reset_column_information
      Discussion.record_timestamps = false
      Discussion.all.each do |discussion|
         discussion.first_message_id = discussion.messages.first.id
         discussion.last_message_id  = discussion.messages.last.id
         discussion.save validate: false
      end
      Discussion.record_timestamps = true

      remove_column :messages, :first
      remove_column :messages, :last
   end
end
