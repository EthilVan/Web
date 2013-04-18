class AddRememberedAuthTokenToAccount < ActiveRecord::Migration

   def self.up
      add_column(:accounts, :remembered_auth_token, :string, limit: 60)
   end

   def self.down
      remove_column(:accounts, :remembered_auth_token)
   end
end
