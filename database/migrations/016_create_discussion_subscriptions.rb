class CreateDiscussionSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :discussion_subscriptions do |t|
      t.integer :discussion_id
      t.integer :account_id
    end
  end

  def self.down
    drop_table :discussion_subscriptions
  end
end
