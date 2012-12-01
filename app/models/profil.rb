class Profil < ActiveRecord::Base

   def avatar_link
      if avatar.present?
         avatar
      else
         head_link
      end
   end
end
