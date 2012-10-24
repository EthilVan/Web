class CreatePrivateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :private_discussions do |t|
      t.integer :owner_id
      t.integer :receiver_id
    end
  end

  def self.down
    drop_table :private_discussions
  end
end
