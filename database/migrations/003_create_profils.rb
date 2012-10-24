# encoding: UTF-8
class CreateProfils < ActiveRecord::Migration

    def self.up
        create_table :profils do |t|
            t.integer :account_id
            t.timestamp :created_at
            # ===============================
            t.string :minecraft_since
            t.integer :favorite_block, :default => 0
            t.integer :favorite_item, :default => 0
            t.string :skill
            t.text :desc_rp
            # ===============================
            t.date :birthdate
            t.string :sexe
            t.text :localisation
            # ===============================
            t.string :website
            t.string :twitter
            t.string :youtube
            t.text :description
        end
    end

    def self.down
        drop_table :profils
    end

end
