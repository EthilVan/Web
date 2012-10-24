# encoding: UTF-8
class CreateNotifications < ActiveRecord::Migration

    def self.up
        create_table :notifications do |t|
            t.integer :account_id
            t.integer :type
            t.integer :type_id
            t.timestamp :created_at
        end
    end

    def self.down
        drop_table :notifications
    end

end
