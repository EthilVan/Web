class Postulation < ActiveRecord::Base

   include BCrypt

   attr_accessible :name
   attr_accessible :minecraft_name
   attr_accessible :email
   attr_accessible :password
   attr_accessible :password_confirmation
   attr_accessible :birthdate_formatted
   attr_accessible :sexe
   attr_accessible :minecraft_since
   attr_accessible :multi_minecraft
   attr_accessible :old_server
   attr_accessible :old_server_reason
   attr_accessible :ethilvan_discovered
   attr_accessible :ethilvan_reason
   attr_accessible :availability_schedule
   attr_accessible :microphone
   attr_accessible :mumble
   attr_accessible :mumble_other
   attr_accessible :free_text

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account, inverse_of: :postulation
   has_many   :screens,  class_name: 'PostulationScreen'

   # ==========================================================================
   # * Validations
   # ==========================================================================

   # Presence
   validates_presence_of   :name
   validates_presence_of   :email
   validates_presence_of   :minecraft_name

   # Uniqueness
   def self.validates_uniqueness_with_account_of(field_name)
      validate do |record|
         field = record[field_name]
         query = Postulation.where(field_name => field)
         query = query.where('id != ?', record.id) if record.persisted?
         exist = query.size > 0
         if record.status == 0
            exist ||= Account.where(field_name => field).size > 0
         end

         record.errors.add(field_name, :taken) if exist
      end
   end

   validates_uniqueness_with_account_of :name
   validates_uniqueness_with_account_of :email
   validates_uniqueness_with_account_of :minecraft_name

   # Format
   validates_format_of :name, with: /\A#{Account::NAME}\Z/, allow_blank: true
   validates_length_of :email, in: 5..100, allow_blank: true
   validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
      allow_blank: true

   # Password
   validates_presence_of     :password,              if: :new_password?
   validates_presence_of     :password_confirmation, if: :new_password?
   validates_confirmation_of :password,              if: :new_password?

   # Birthdate Format
   class BirthDateValidator < ActiveModel::Validator

      def validate(record)
         return if record.birthdate_formatted.blank?
         if record.birthdate_formatted =~ /^(\d{2})\/(\d{2})\/(\d{4})$/
            return if Date.valid_civil?($3.to_i, $2.to_i, $1.to_i)
         end
         record.errors.add(:birthdate_formatted, :invalid)
      end
   end
   validates_with BirthDateValidator

   # Sexe
   validates_inclusion_of :sexe, in: EthilVan::Data::Sexe.map(&:second)

   # Length
   validates_length_of :minecraft_since,       minimum:  20
   validates_length_of :ethilvan_discovered,   minimum:  60
   validates_length_of :ethilvan_reason,       minimum: 120
   validates_length_of :availability_schedule, minimum:  20

   validates_length_of :old_server,        minimum: 100, if: :multi_minecraft
   validates_length_of :old_server_reason, minimum: 100, if: :multi_minecraft
   validates_length_of :mumble_other,      minimum:  20, if: :mumble_other?

   # Mumble
   validates_inclusion_of :mumble, in: EthilVan::Data::Mumble, if: :microphone

   # Rules acceptance
   validates_acceptance_of :rules_acceptance, allow_nil: false, on: :create

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   before_save :encrypt_password, if: :new_password?
   scope :by_date, order('created_at DESC')
   scope :awaiting, where('`postulations`.`status` != 2')

   # ==========================================================================
   # * Methods
   # ==========================================================================
   attr_accessor :password
   attr_accessor :password_confirmation
   attr_writer   :birthdate_formatted
   attr_accessor :rules_acceptance

   def birthdate_formatted
      if @birthdate_formatted.present? or birthdate.nil?
         @birthdate_formatted
      else
         birthdate.strftime EthilVan::Data::DATE_FORMAT
      end
   end

private

   def new_password?
      crypted_password.blank? || password.present?
   end

   def encrypt_password
      self.crypted_password = Password.create(password)
   end

   def mumble_other?
      mumble == EthilVan::Data::Mumble.last
   end
end
