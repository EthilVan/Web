class Login

   include ActiveModel::Validations

   validates_presence_of :name
   validates_presence_of :password
   validate :authentication, if: :has_credentials?

   attr_accessor :name
   attr_accessor :password
   attr_accessor :remember
   attr_reader   :account
   attr_reader   :banned

   def initialize(params = {})
      @name = params[:name]
      @password = params[:password]
      @remember = params[:remember] || false
      @banned = false
   end

   def read_attribute_for_validation(key)
      return nil unless [:name, :password, :remember].include? key
      return send(key)
   end

   def has_credentials?
      @name.present?
      @password.present?
   end

   def authentication
      @account = Account.authenticate(name, password)
      if @account.nil?
         errors.add(:credentials, :invalid)
      elsif @account.banned
         @banned = true
         errors.add(:credentials, :banned)
      end
   end
end
