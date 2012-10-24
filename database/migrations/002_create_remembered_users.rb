# encoding: UTF-8
class CreateRememberedUsers < ActiveRecord::Migration

    def self.up
        create_table :remembered_users do |t|
            t.integer :account_id
            t.string :token_hash
        end
    end

    def self.down
        drop_table :remembered_users
    end

end
