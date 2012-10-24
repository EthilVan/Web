# encoding: UTF-8
class CreatePostulationVotes < ActiveRecord::Migration

    def self.up
        create_table :postulation_votes do |t|
            t.integer :account_id
            t.integer :postulation_id
            t.boolean :agreement
        end
    end

    def self.down
        drop_table :postulations_votes
    end

end
