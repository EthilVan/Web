module EthilVan::App::Views

   module Public

      module Contact

         class Index < Page

            CATEGORIES = %[general partnership development]

            include EthilVan::Mustache::Form

            def initialize(contact_email = nil)
               @contact_email = contact_email
            end

            def errors?
               !@contact_email.nil? && !@contact_email.errors.empty?
            end

            def errors
               @contact_email.errors.map { |field, message| message }
            end

            def name
               field(@contact_email.nil? ? nil : @contact_email.name)
            end

            def email
               field(@contact_email.nil? ? nil : @contact_email.email)
            end

            def category
               categories = @contact_email.nil? ? nil : @contact_email.category
               select categories, CATEGORIES
            end

            def subject
               field(@contact_email.nil? ? nil : @contact_email.subject)
            end

            def message
               @contact_email.nil? ? nil : @contact_email.message
            end
         end
      end
   end
end
