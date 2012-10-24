class CreateGeneralDiscussionGroups < ActiveRecord::Migration
  def self.up
    create_table :general_discussion_groups do |t|
    end
  end

  def self.down
    drop_table :general_discussion_groups
  end
end
