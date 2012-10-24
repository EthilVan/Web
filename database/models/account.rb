require 'securerandom'

class Account < ActiveRecord::Base

   before_create :generate_auth_token

   def self.authenticate(name, password)
      return nil unless name.present?
      account = find_by_name name
      return nil if account.nil?
      return nil unless account.check_password?(password)
      return account
   end

   def check_password?(password)
     ::BCrypt::Password.new(crypted_password) == password
   end

   def generate_auth_token
      begin
         new_auth_token = SecureRandom.base64(75)
      end until Account.find_by_auth_token(new_auth_token).nil?
      self.auth_token = new_auth_token
   end
 end
