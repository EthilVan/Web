class AddUpdatedAtToNews < ActiveRecord::Migration

  def self.up
    add_column :news, :updated_at, :timestamp
    New.all.each do |n|
      n.updated_at = n.created_at
      n.save
    end
  end

  def self.down
    remove_column :news, :updated_at
  end

end