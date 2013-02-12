module EthilVan::App::Views

   module Member::Profil::Edit

      class Account < Partial

         class Form < EthilVan::Mustache::Form

            def initialize(account, action)
               super(account, action: action)
            end

            def email
               text :email, validations: { type: 'email' }
            end

            def password
               password_f :password
            end

            def password_confirmation
               password_f :password_confirmation, validations: {
                  equalTo: '#account_password',
               }
            end
         end

         def initialize(account, params)
            @form = Form.new(account, urls.profil_edit('compte', account))
            @params = params
         end

         def ok?
            @params[:ok]
         end

         def invalid_current_password?
            @params[:invalid_current_password]
         end

         def form
            @form
         end
      end
   end
end
