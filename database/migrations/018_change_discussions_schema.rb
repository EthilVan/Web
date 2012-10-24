class ChangeDiscussionsSchema < ActiveRecord::Migration

  def self.up
    change_column  :discussions, :discussion_group_type, :string
    add_column :general_discussion_groups, :name, :string
    add_column :general_discussion_groups, :description, :text
    add_column :general_discussion_groups, :priority, :integer, :default => 30
    add_column :discussions, :name, :string
  end

  def self.down
    change_column  :discussions, :discussion_group_type, :integer
    remove_column :general_discussion_groups, :description
    remove_column :general_discussion_groups, :priority
    remove_column :discussions, :name
  end

end