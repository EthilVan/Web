# encoding: UTF-8
class AddAvatarToProfils < ActiveRecord::Migration

  def up
    add_column :profils, :avatar, :string
  end

  def down
    remove_column :profils, :avatar
  end
  
end
