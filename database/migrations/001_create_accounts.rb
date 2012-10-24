class CreateAccounts < ActiveRecord::Migration

    def self.up
        create_table :accounts do |t|
            t.string :name
            t.string :email
            t.string :crypted_password
            t.string :role
            t.string :minecraft_name
            t.datetime :last_visit
        end
        add_index(
            :accounts,
            [:name, :minecraft_name, :email],
            :unique => true
        )
    end

    def self.down
        drop_table :accounts
    end

end
