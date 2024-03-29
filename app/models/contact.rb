class ContactEmail

   CATEGORIES = EthilVan::Data::Contact::Categories

   include ActiveModel::Validations

   validates_presence_of :name
   validates_format_of   :name,
         with: /\A[a-z][a-z0-9_ ]+\Z/i,
         allow_blank: true
   validates_presence_of :email
   validates_format_of   :email,
         with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
         allow_blank: true
   validates_presence_of :subject
   validates_presence_of :message
   validates_inclusion_of :category,
         in: EthilVan::Data::Contact::Categories.keys

   def initialize(attributes = {})
      @attributes = attributes
   end

   def name
      @attributes['name']
   end

   def name=(new_name)
      @attributes['name'] = new_name
   end

   def email
      @attributes['email']
   end

   def email=(new_email)
      @attributes['email'] = new_email
   end

   def category
      @attributes['category']
   end

   def category=(new_category)
      @attributes['category'] = new_category
   end

   def subject
      @attributes['subject']
   end

   def subject=(new_subject)
      @attributes['subject'] = new_subject
   end

   def message
      @attributes['message']
   end

   def message=(new_message)
      @attributes['message'] = new_message
   end

   def read_attribute_for_validation(key)
      @attributes[key.to_s]
   end
end
