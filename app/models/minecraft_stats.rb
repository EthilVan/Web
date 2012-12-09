class MinecraftStats < ActiveRecord::Base

   belongs_to :account, inverse_of: :minecraft_stats
end
