# encoding: utf-8

module EthilVan::App::Views

   module Public::Contact

      class Index < Page

         class Form < EthilVan::Mustache::ModelForm

            CATEGORIES = {
               general: 'Général',
               partnership: 'Partenariat',
               development: 'Développement'
            }

            def initialize(contact_email)
               super(contact_email)
            end

            def name
               text :name
            end

            def email
               text :email, type: :email
            end

            def category
               select :category, CATEGORIES
            end

            def subject
               text :subject
            end

            def message
               text :message
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
