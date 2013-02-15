module EthilVan::App::Views

   class Mail < Partial

      def sender
         EthilVan::Config.mail_sender
      end

      def mail_subject
         lambda { |text| @_subject = text; nil }
      end

      def subject
         @_subject || 'No subject !'
      end
   end

   module Mails
   end
end
