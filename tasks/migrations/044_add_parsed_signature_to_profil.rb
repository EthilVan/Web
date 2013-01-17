class AddParsedSignatureToProfil < ActiveRecord::Migration

   def self.up
      add_column(:profils, :parsed_signature, :text, default: nil)

      Profil.reset_column_information
      Profil.all.each &:save
   end

   def self.down
      remove_column(:profils, :parsed_signature)
   end
end
