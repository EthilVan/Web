require 'securerandom'
require 'bcrypt'

class Account < ActiveRecord::Base

   include BCrypt

   AUTH_TOKEN_COST = 5

   has_one :profil, inverse_of: :account
   has_one :minecraft_stats, inverse_of: :account
   before_save :encrypt_password, :if => :new_password?

   def self.authenticate(name, password)
      return nil unless name.present?
      account = find_by_name name
      return nil if account.nil?
      return nil unless account.check_password?(password)
      return account
   end

   def self.authenticate_by_token(name, auth_token)
      account = find_by_name name
      return nil if account.nil?
      return nil unless account.check_token?(auth_token)
      return account
   end

   attr_accessor :password

   def role
      EthilVan::Role.get role_id.to_sym
   end

   def logged_in?
      true
   end

   def check_password?(password)
      Password.new(crypted_password) == password
   end

   def check_token?(token)
      Password.new(auth_token) == token
   end

  def new_password?
     crypted_password.blank? || password.present?
  end

  def encrypt_password
     self.crypted_password = Password.create(password)
  end

  def generate_auth_token
      raw_auth_token = SecureRandom.base64(180)
      self.auth_token = Password.create(raw_auth_token, cost: AUTH_TOKEN_COST)
      save validate: false
      return raw_auth_token
   end

   def delete_auth_token
      self.auth_token = nil
      save validate: false
   end
end
