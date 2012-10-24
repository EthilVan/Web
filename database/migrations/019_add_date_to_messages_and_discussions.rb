class AddDateToMessagesAndDiscussions < ActiveRecord::Migration

  def self.up
    add_column :discussions, :created_at, :timestamp
    add_column :messages, :created_at, :timestamp
    add_column :messages, :updated_at, :timestamp
  end

  def self.down
    remove_column :discussions, :created_at
    remove_column :messages, :created_at
    remove_column :messages, :updated_at
  end

end