module EthilVan::App::Views

   class Mails::Contact < Mail

      def initialize(contact_email)
         @contact_email = contact_email
      end

      def sender
         "#{@contact_email.name} <#{@contact_email.email}>"
      end

      def receiver
         EthilVan::Data::Contact::Receiver[category]
      end

      def subject
         dcategory = EthilVan::Data::Contact::Categories[category]
         "[#{dcategory}] #{@contact_email.subject}"
      end

      def category
         @contact_email.category
      end

      def message
         @contact_email.message
      end
   end
end
