class AddVoteNeededToAccount < ActiveRecord::Migration

   def self.up
      add_column(:accounts, :vote_needed, :boolean, default: true)
   end

   def self.down
      remove_column(:accounts, :vote_needed)
   end
end
