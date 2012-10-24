# encoding: UTF-8
class AddBannedToAccount < ActiveRecord::Migration

  def up
    add_column :accounts, :banned, :boolean, :default => false
  end

  def down
    remove_column :accounts, :banned
  end
  
end
