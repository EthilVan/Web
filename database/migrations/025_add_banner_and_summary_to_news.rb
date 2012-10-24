class AddBannerAndSummaryToNews < ActiveRecord::Migration

   def self.up
      add_column :news, :banner, :string
      add_column :news, :summary, :text
   end

   def self.down
      remove_column :news, :banner
      remove_column :news, :summary
   end
end
