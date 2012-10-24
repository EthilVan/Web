# encoding: UTF-8
class CreateVisitors < ActiveRecord::Migration

    def self.up
        create_table :visitors, :primary_key => "visitor_id" do |t|
            t.string :name
            t.datetime :last_minecraft_visit;
        end
    end

    def self.down
        drop_table :visitors
    end

end
