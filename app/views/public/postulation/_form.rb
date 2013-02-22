# encoding: utf-8

module EthilVan::App::Views

   module Public::Postulation

      class Formulaire::Form < EthilVan::Mustache::Form

         class ScreenFields < EthilVan::Mustache::Form::Association

            def self.model_template
               PostulationScreen.new
            end

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
               nameformat: true,
            }
         end

         def minecraft_name
            text :minecraft_name, validations: {
               required: true,
               nameformat: true,
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
               datefr: true,
            }
         end

         def sexe
            choice :sexe, among: EthilVan::Data::Sexe
         end

         def minecraft_since
            text :minecraft_since, validations: {
               required: true,
               minlength: 20,
            }
         end

         def multi_minecraft
            boolean :multi_minecraft
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
            boolean :microphone
         end

         def mumble
            choice :mumble, among: EthilVan::Data::Mumble
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

         def screens
            association ScreenFields, :screens
         end

         def rules_acceptance
            boolean :rules_acceptance, validations: {
               acceptance: 'règlement',
            }
         end
      end
   end
end
