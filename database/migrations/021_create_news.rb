class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.integer :account_id
      t.string :title
      t.text :contents
      t.timestamp :created_at
      t.boolean :important
      t.boolean :private
    end
  end

  def self.down
    drop_table :news
  end
end
