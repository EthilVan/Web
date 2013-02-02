# encoding: utf-8

module EthilVan::App::Views

   module Public::Contact

      class Index < Page

         class Form < EthilVan::Mustache::Form

            CATEGORIES = {
               general: 'Général',
               partnership: 'Partenariat',
               development: 'Développement'
            }

            def initialize(contact_email)
               super(contact_email)
            end

            def name
               text :name, validations: {
                  required: true,
                  regexp: "^[A-Za-z][A-Za-z0-9_ ]+$",
               }
            end

            def email
               text :email, validations: {
                  required: true,
                  type: 'email',
               }
            end

            def category
               select :category, among: CATEGORIES
            end

            def subject
               text :subject, validations: {
                  required: true,
               }
            end

            def message
               text :message, validations: {
                  required: true,
               }
            end
         end

         def initialize(contact_email = ContactEmail.new)
            @form = Form.new(contact_email)
         end

         def form
            @form
         end
      end
   end
end
