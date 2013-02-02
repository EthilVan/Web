module EthilVan::App::Views

   module Public::Postulation

      class Formulaire::Form < EthilVan::Mustache::Form

         class ScreenFields < EthilVan::Mustache::Form::Association

            def url
               text :url, validations: {
                  required: true,
                  type: 'urlstrict',
               }
            end

            def description
               text :description, validations: {
                  required: true,
                  minlength: 20,
               }
            end
         end

         def initialize(postulation)
            super(postulation)
         end

         def name
            text :name, validations: {
               required: true,
               regexp: "^#{Account::NAME}$",
            }
         end

         def minecraft_name
            text :minecraft_name, validations: {
               required: true,
            }
         end

         def email
            text :email, validations: {
               required: true,
               type: 'email',
            }
         end

         def password
            password_f :password, validations: {
               required: true,
            }
         end

         def password_confirmation
            password_f :password_confirmation, validations: {
               required: true,
               equalTo: '#postulation_password',
            }
         end

         def birthdate
            text :birthdate_formatted, validations: {
               regexp: '^(\d{2})\/(\d{2})\/(\d{4})$',
            }
         end

         def sexe
            select :sexe, {
               among: Hash[*EthilVan::Data::Sexe.map(&:reverse).flatten]
            }
         end

         def minecraft_since
            text :minecraft_since, validations: {
               required: true,
               minlength: 20,
            }
         end

         def multi_minecraft
            checkbox :multi_minecraft
         end

         def old_server
            text :old_server, validations: {
               required: true,
               minlength: 100,
            }
         end

         def old_server_reason
            text :old_server_reason, validations: {
               required: true,
               minlength: 100,
            }
         end

         def ethilvan_discovered
            text :ethilvan_discovered, validations: {
               required: true,
               minlength: 60,
            }
         end

         def ethilvan_reason
            text :ethilvan_reason, validations: {
               required: true,
               minlength: 120,
            }
         end

         def availability
            text :availability_schedule, validations: {
               required: true,
               minlength: 20,
            }
         end

         def microphone
            checkbox :microphone
         end

         def mumble
            select :mumble, among: EthilVan::Data::Mumble
         end

         def mumble_other
            text :mumble_other, validations: {
               required: true,
               minlength: 20,
            }
         end

         def free_text
            text :free_text
         end

         def screen_template
            nil # associationScreenFields.new(PostulationScreen.new, @base_name, 0)
         end

         def screens
            association ScreenFields, :screens
         end

         def rules_acceptance
            checkbox :rules_acceptance, validations: {
               required: true,
            }
         end
      end
   end
end
