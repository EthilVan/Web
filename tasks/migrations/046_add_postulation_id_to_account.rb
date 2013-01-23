class AddPostulationIdToAccount < ActiveRecord::Migration

   def self.up
      add_column(:accounts, :postulation_id, :integer)

      Account.reset_column_information
      Account.all.each do |account|
         postulation = Postulation.where(name: account.name).first
         next if postulation.nil?
         account.postulation_id = postulation.id
         account.save validate: false
      end
   end

   def self.down
      remove_column(:accounts, :postulation_id)
   end
end
