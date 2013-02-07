require 'securerandom'
require 'bcrypt'

class Account < ActiveRecord::Base

   include BCrypt
   NAME = '[A-Za-z]\w+'
   AUTH_TOKEN_COST = 5

   attr_accessible :email
   attr_accessible :password
   attr_accessible :password_confirmation

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :postulation,  inverse_of: :account
   has_one :profil,          inverse_of: :account
   has_one :minecraft_stats, inverse_of: :account
   has_many :profil_tags,    foreign_key: :tagged_id, order: 'created_at DESC'
   has_many :discussion_views

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_format_of :name, with: /\A#{NAME}\Z/

   validates_length_of :email, within: 3..100
   validates_format_of :email,
         with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

   validates_presence_of   :minecraft_name

   # Uniqueness
   def self.validates_uniqueness_with_postulation_of(field_name)
      validate do |record|
         field = record[field_name]
         query = Account.where(field_name => field)
         query = query.where('id != ?', record.id) if record.persisted?
         exist = query.exists?
         exist ||= Postulation.awaiting.where(field_name => field).exists?

         record.errors.add(field_name, :taken) if exist
      end
   end

   validates_uniqueness_with_postulation_of :name
   validates_uniqueness_with_postulation_of :email
   validates_uniqueness_with_postulation_of :minecraft_name

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
   def self.create_from_postulation(postulation)
      account = new
      account.name              = postulation.name
      account.email             = postulation.email
      account.crypted_password  = postulation.crypted_password
      account.minecraft_name    = postulation.minecraft_name
      account.postulation_id     = postulation.id
      account.role_id           = 'default'
      profil = account.profil   = Profil.create
      profil.minecraft_since    = postulation.minecraft_since
      profil.birthdate          = postulation.birthdate
      profil.sexe               = postulation.sexe
      account.minecraft_stats   = MinecraftStats.create

      if account.save and profil.save and account.minecraft_stats.save
         account
      else
         nil
      end
   end

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

   def views_by_discussion_id
      discussion_views.group_by { |view| view.discussion_id }
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

   def clear_new_password
      self.password = self.password_confirmation = nil
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
