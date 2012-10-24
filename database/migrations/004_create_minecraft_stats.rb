# encoding: UTF-8
class CreateMinecraftStats < ActiveRecord::Migration

    def self.up
        create_table :minecraft_stats do |t|
            t.integer :account_id
            t.datetime :last_visit
            t.integer :version, :default => 0
        end
    end

    def self.down
        drop_table :profils
    end

end
