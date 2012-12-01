class UpdateAuthenticationSystem < ActiveRecord::Migration

   def self.up
      add_column :accounts, :auth_token, :string, limit: 100
      add_index :accounts, :auth_token, unique: true
      drop_table :remembered_users

      Account.all.each do |account|
         account.generate_auth_token
         account.save
      end
   end

   def self.down
      create_table :remembered_users do |t|
          t.integer :account_id
          t.string :token_hash
      end
      remove_index :accounts, :auth_token
      remove_column :accounts, :auth_token
   end
end
