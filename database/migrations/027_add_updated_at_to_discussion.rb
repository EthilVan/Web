class AddUpdatedAtToDiscussion < ActiveRecord::Migration

  def self.up
    add_column :discussions, :updated_at, :timestamp
    Discussion.all.each do |discussion|
      discussion.updated_at = discussion.messages.last.created_at
      discussion.save
    end
  end

  def self.down
    remove_column :discussions, :updated_at
  end

end