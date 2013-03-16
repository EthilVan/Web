module EthilVan::App::Views

   module Public::ForgottenPassword

      class NewPassword < Page

         class Form < EthilVan::Mustache::Form

            def initialize(account)
               super(account)
            end

            def password
               password_f :password
            end

            def password_confirmation
               password_f :password_confirmation
            end
         end

         def initialize(account)
            @form = Form.new(account)
         end

         def form
            @form
         end
      end
   end
end
