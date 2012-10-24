# encoding: UTF-8
class CreateBans < ActiveRecord::Migration

    def self.up
        create_table :bans do |t|
            t.string :name
            t.string :minecraft_name
            t.string :email
            t.timestamp :created_at
        end
    end

    def self.down
        drop_table :bans
    end

end
