# encoding: UTF-8
class AddMaxLevelAndDeathsToMinecraftStats < ActiveRecord::Migration

  def up
    add_column :minecraft_stats, :deaths, :integer, :default => 0
    add_column :minecraft_stats, :max_level, :integer, :default => 0
  end

  def down
    remove_column :minecraft_stats, :deaths
    remove_column :minecraft_stats, :max_level
  end
  
end
