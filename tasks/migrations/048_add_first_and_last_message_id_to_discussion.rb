class AddFirstAndLastMessageIdToDiscussion < ActiveRecord::Migration

   def self.up
      add_column(:discussions, :first_message_id, :integer)
      add_column(:discussions, :last_message_id,  :integer)

      add_index(:discussions, :first_message_id, unique: true)
      add_index(:discussions, :last_message_id,  unique: true)

      Discussion.reset_column_information
      Discussion.record_timestamps = false
      Discussion.all.each do |discussion|
         discussion.first_message_id = discussion.messages.first.id
         discussion.last_message_id  = discussion.messages.last.id
         discussion.save validate: false
      end
   end

   def self.down
      remove_index(:discussions, column: :first_message_id)
      remove_index(:discussions, column: :last_message_id)

      remove_column(:discussions, :first_message_id)
      remove_column(:discussions, :last_message_id)
   end
end
