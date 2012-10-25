class RenameAccountsRoleToRoleId < ActiveRecord::Migration

   def self.up
      rename_column(:accounts, :role, :role_id)
   end

   def self.down
      rename_column(:accounts, :role_id, :role)
   end
end
