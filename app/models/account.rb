require 'securerandom'
require 'bcrypt'

class Account < ActiveRecord::Base

   include BCrypt
   NAME = '[A-Za-z]\w+'
   AUTH_TOKEN_COST = 5

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :postulation,  inverse_of: :account
   has_one :profil,          inverse_of: :account
   has_one :minecraft_stats, inverse_of: :account
   has_many :profil_tags,    foreign_key: :tagged_id

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_format_of :name, with: /\A#{NAME}\Z/

   validates_length_of :email, within: 3..100
   validates_format_of :email,
         with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

   validates_presence_of   :minecraft_name

   validates_uniqueness_of :name
   validates_uniqueness_of :email
   validates_uniqueness_of :minecraft_name

   # Uniqueness taking 'Postulation' in account
   validate do |record|
      awaiting_postulations = Postulation.awaiting
      exist = awaiting_postulations.where(name: record.name).size > 0
      record.errors[:name] = 'Name already taken' if exist

      exist = awaiting_postulations.where(email: record.email).size > 0
      record.errors[:email] = 'Email already taken' if exist

      exist = awaiting_postulations.where(minecraft_name: record.minecraft_name).size > 0
      record.errors[:minecraft_name] = 'Minecraft name already taken' if exist
   end

   validates_presence_of     :password,              if: :new_password?
   validates_presence_of     :password_confirmation, if: :new_password?
   validates_confirmation_of :password,              if: :new_password?

   validates_inclusion_of :role_id, within: EthilVan::Role.ids.map(&:to_s)

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   before_save :encrypt_password, if: :new_password?
   scope :with_profil, includes(:profil)
   scope :with_everything, includes(:profil).includes(:postulation).
         includes(:minecraft_stats)

   # ==========================================================================
   # * Methods
   # ==========================================================================
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

   attr_accessor :password, :password_confirmation

   def role
      EthilVan::Role.get role_id.to_sym
   end

   def logged_in?
      true
   end

   def online?
      return false if last_visit.nil?
      return last_visit >= 5.minutes.ago
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
      auth_token = Password.create(raw_auth_token, cost: AUTH_TOKEN_COST)
      update_attribute :auth_token, auth_token
      return raw_auth_token
   end

   def delete_auth_token
      update_attribute :auth_token, nil
   end
end
