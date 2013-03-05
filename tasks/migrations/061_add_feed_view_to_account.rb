class AddFeedViewToAccount < ActiveRecord::Migration

   def self.up
      add_column(:accounts, :feed_view, :timestamp, default: Time.at(0))
   end

   def self.down
      remove_column(:accounts, :feed_view)
   end
end
