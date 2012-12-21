class Profil < ActiveRecord::Base

   belongs_to :account, inverse_of: :profil

   def head_url(size = nil)
      EthilVan::Urls.skin_head(account.name, size)
   end

   def avatar_url
      return head_url(15) if avatar.nil?
      return avatar
   end
end
