class AddAvailabilityToProfil < ActiveRecord::Migration

   def self.up
      add_column(:profils, :availability, :text)

      Profil.reset_column_information
      Profil.all.each do |profil|
         profil.availability = profil.account.postulation.availability_schedule
         profil.save
      end
   end

   def self.down
      remove_column(:profils, :availability)
   end
end
