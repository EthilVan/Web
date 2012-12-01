class UpdateAuthenticationSystemAgain < ActiveRecord::Migration

   def self.up
      change_column :accounts, :auth_token, :string, limit: 60
      Account.reset_column_information
      Account.all.each { |account| account.delete_auth_token }
   end

   def self.down
      change_column :accounts, :auth_token, :string, limit: 100
      Account.reset_column_information
      Account.all.each { |account| account.generate_auth_token }
   end
end
