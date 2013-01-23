class FixExistingPostulationCryptedPassword < ActiveRecord::Migration

   def self.up
      Postulation.all.each do |postulation|
         next if postulation.crypted_password.present?
         postulation.update_attribute :crypted_password, 'crypted_password'
      end
   end

   def self.down
   end
end
