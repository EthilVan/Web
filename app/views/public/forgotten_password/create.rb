module EthilVan::App::Views

   module Public::ForgottenPassword

      class Create < Page

         def initialize(email = '', error = false)
            @email = email
            @error = error
         end

         def error?
            @error
         end

         def email
            @email
         end
      end
   end
end
