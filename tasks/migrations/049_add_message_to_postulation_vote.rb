class AddMessageToPostulationVote < ActiveRecord::Migration

   def self.up
      add_column(:postulation_votes, :message, :text)
   end

   def self.down
      remove_column(:postulation_votes, :message)
   end
end
