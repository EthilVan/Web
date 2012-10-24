class AddSteamIdToProfil < ActiveRecord::Migration

  def self.up
    add_column :profils, :steam_id, :string
  end

  def self.down
    remove_column :profils, :steam_id
  end

end