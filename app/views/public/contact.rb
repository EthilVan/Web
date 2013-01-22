module EthilVan::App::Views

   module Public::Contact

      class Index < Page

         CATEGORIES = %w{general partnership development}

         include EthilVan::Mustache::Form

         def initialize(contact_email = ContactEmail.new)
            @contact_email = contact_email
         end

         def errors?
            !@contact_email.errors.empty?
         end

         def errors
            @contact_email.errors.to_a
         end

         def name
            field @contact_email.name
         end

         def email
            field @contact_email.email
         end

         def category
            select @contact_email.category, CATEGORIES
         end

         def subject
            field @contact_email.subject
         end

         def message
            @contact_email.message
         end
      end
   end
end
