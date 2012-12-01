# encoding: utf-8

module EthilVan

   class ContactEmail

      CATEGORIES = %(general partnership development)

      include ActiveModel::Validations

      validates_presence_of :name,    message: "Nom obligatoire."
      validates_presence_of :email,   message: "Email obligatoire."
      validates_presence_of :subject, message: "Sujet obligatoire."

      validates_format_of :name,
            with: /\A[a-z][a-z0-9_ ]+\Z/i,
            allow_nil: true,
            message: "Format du nom invalide."

      validates_format_of :email,
            with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            allow_nil: true,
            message: "Email invalide."

      validate :validate_category


      def initialize(attributes)
         @attributes = attributes
      end

      def name
         @attributes['name']
      end

      def email
         @attributes['email']
      end

      def category
         @attributes['category']
      end

      def subject
         @attributes['subject']
      end

      def message
         @attributes['message']
      end

      def read_attribute_for_validation(key)
         @attributes[key.to_s]
      end

      def validate_category
         unless CATEGORIES.include? @attributes['category']
            errors.add(:category, "Categorie invalide.")
         end
      end

      def sender
         "#{@attributes['name']} <#{@attributes['email']}>"
      end

      def categorized_subject
         "[#{@attributes['category']}] #{@attributes['subject']}"
      end

      def body
         return <<-BODY
Envoyé depuis l'interface web :
De: #{sender}
Sujet: #{subject}

#{@attributes['message']}
         BODY
      end
   end
end
