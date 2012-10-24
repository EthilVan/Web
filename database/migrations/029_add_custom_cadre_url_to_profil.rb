class AddCustomCadreUrlToProfil < ActiveRecord::Migration

  def self.up
    add_column :profils, :custom_cadre_url, :string
  end

  def self.down
    remove_column :profils, :custom_cadre_url
  end

end