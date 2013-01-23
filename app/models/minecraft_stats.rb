class MinecraftStats < ActiveRecord::Base

   attr_accessible :last_visit
   attr_accessible :deaths
   attr_accessible :max_level

   belongs_to :account, inverse_of: :minecraft_stats
end
