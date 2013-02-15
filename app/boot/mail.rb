require_relative 'env'
require 'mail'

Mail.defaults do
   delivery_method *EthilVan::Config.mail_delivery_method
end

module EthilVan::Mail

   def self.registered(app)
      app.helpers self
   end

   def mail(template)
      mail_body = mail_mustache(template)

      mail_view = @mustache_mail_view
      if EthilVan::Config.mail_test_receiver?
         subject = "[FWD :  #{mail_view.receiver}]" + mail_view.subject
         receiver = EthilVan::Config.mail_test_receiver
      else
         subject = mail_view.subject
         receiver = mail_view.receiver
      end

      Mail.deliver do
         self.charset = 'UTF-8'
         from    mail_view.sender
         to      receiver
         subject subject
         body    mail_body
      end
   end
end
