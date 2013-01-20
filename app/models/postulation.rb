class Postulation < ActiveRecord::Base

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account, inverse_of: :postulation
   has_many :screens, :class_name => "PostulationScreen"

   # ==========================================================================
   # * Validations
   # ==========================================================================

   # Presence
   validates_presence_of   :name
   validates_presence_of   :email
   validates_presence_of   :minecraft_name

   # Uniqueness
   validates_uniqueness_of :name
   validates_uniqueness_of :email
   validates_uniqueness_of :minecraft_name

   # Uniqueness taking Account in account
   validate do |record|
      exist = Account.where(name: record.name).size > 0
      record.errors[:name] = "Name already taken" if exist

      exist = Account.where(email: record.email).size > 0
      record.errors[:email] = "Email already taken" if exist

      exist = Account.where(minecraft_name: record.minecraft_name).size > 0
      record.errors[:minecraft_name] = "Minecraft name already taken" if exist
   end

   # Format
   validates_format_of :name, with: /\A#{Account::NAME}\Z/
   validates_length_of :email, in: 3..100
   validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   scope :by_date, order('created_at DESC')

end
