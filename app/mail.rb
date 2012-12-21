require_relative 'env'
require 'mail'

Mail.defaults do
   delivery_method *EthilVan::Config.mail_delivery_method
end

module EthilVan::Mail

   def self.registered(app)
      app.helpers self
   end

   def mail(&block)
      Mail.deliver do
         self.charset = 'UTF-8'
         self.from EthilVan::Config.mail_sender
         instance_eval(&block)
      end
   end
end
