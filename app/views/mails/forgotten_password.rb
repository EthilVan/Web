module EthilVan::App::Views

   class Mails::ForgottenPassword < Mail

      def initialize(forgotten_password)
         @forgotten_password = forgotten_password
      end

      def receiver
         @forgotten_password.account.email
      end

      def url
         url = "http://ethilvan.fr/login/oublie/"
         url << @forgotten_password.token
         url
      end
   end
end
