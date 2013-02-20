require 'securerandom'

class ForgottenPassword < ActiveRecord::Base

   EXPIRATION = 1.hour

   belongs_to :account

   def self.create_for(account)
      destroy_all_for(account)
      create(account_id: account.id, expiration: EXPIRATION.from_now,
            token: SecureRandom.urlsafe_base64(190))
   end

   def self.destroy_all_for(account)
      where(account_id: account.id).destroy_all
   end

   def self.destroy_all_expired
      where('expiration <= ?', Time.now).destroy_all
   end

   def expired?
      expiration <= Time.now
   end
end
