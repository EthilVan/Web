class Profil < ActiveRecord::Base

   belongs_to :account, inverse_of: :profil

   def head_url(size = nil)
      url = "/membre/skin/#{account.name}_head"
      url << "_x#{size}" unless size.nil?
      url << '.png'
      url
   end

   def avatar_url
      return head_url(15) if avatar.nil?
      return avatar
   end
end
