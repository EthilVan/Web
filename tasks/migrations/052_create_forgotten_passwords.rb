class CreateForgottenPasswords < ActiveRecord::Migration

   def self.up
      create_table :forgotten_passwords do |t|
         t.string    :token
         t.integer   :account_id
         t.timestamp :expiration
      end
   end

   def self.down
      drop_table :forgotten_passwords
   end
end
