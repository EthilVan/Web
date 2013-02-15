module EthilVan::App::Views

   class Mail < Partial

      def sender
         EthilVan::Config.mail_sender
      end

      def subject
         'No subject !'
      end
   end

   module Mails
   end
end
