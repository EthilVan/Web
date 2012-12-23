class Profil < ActiveRecord::Base

   belongs_to :account, inverse_of: :profil

   def head_url(scale = nil)
      EthilVan::Urls.skin_head(account, scale)
   end

   def avatar_url
      return head_url(15) if avatar.nil?
      return avatar
   end

   def cadre_url
     if custom_cadre_url.present?
         custom_cadre_url
     else
         '/images/membre/profil/cadre.png'
     end
   end
end
