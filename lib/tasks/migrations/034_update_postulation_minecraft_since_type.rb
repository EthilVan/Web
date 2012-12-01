class UpdatePostulationMinecraftSinceType < ActiveRecord::Migration

   def up
      change_column(:postulations, :minecraft_since, :text)
   end

   def down
      change_column(:postulations, :minecraft_since, :string)
   end
end
