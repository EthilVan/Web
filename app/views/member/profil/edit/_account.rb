module EthilVan::App::Views

   module Member::Profil::Edit

      class Account < PageTab

         class Form < EthilVan::Mustache::Form

            def initialize(account, action)
               super(account, action: action)
            end

            def banned
               return false unless super_role?
               boolean :banned
            end

            def vote_needed
               return false unless modo? and role?
               boolean :vote_needed
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

         private

            def role?
               @role ||= has_role?(@model.role)
            end

            def super_role?
               @super_role ||= has_super_role?(@model.role)
            end
         end

         def initialize(page, account, params)
            super(page, 'compte')
            @form = Form.new(account, urls.profil_edit('compte', account))
            @params = params
         end

         def ok?
            @params[:account_ok]
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
