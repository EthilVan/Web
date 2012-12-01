class Profil < ActiveRecord::Base

   belongs_to :account, inverse_of: :profil

   def head_url(size = nil)
      url = "/membre/@#{account.name}/head"
      url << "/#{size}" unless size.nil?
      url
   end

   def avatar_url
      return head_url if avatar.nil?
      return avatar
   end
end
