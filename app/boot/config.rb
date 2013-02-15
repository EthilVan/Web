require 'yaml'

class EthilVan::YamlConfig

   attr :database
   attr :mail_delivery_method
   attr :mail_sender
   attr :mail_test_receiver

   def initialize(path)
      hash = YAML.load_file path
      load_database(hash)
      load_mail(hash)
   end

   def mail_test_receiver?
      @mail_test_receiver_enabled
   end

   def load_database(hash)
      @database = {
         'adapter'   => 'mysql2',
         'encoding'  => 'utf8',
         'reconnect' => true,
         'pool'      => 5,
         'host'      => 'localhost',
      }.merge(hash['database'][EthilVan::ENV.to_s])
   end

   def load_mail(hash)
      if EthilVan.test? or not hash.key? 'mail'
         @mail_delivery_method = [:test]
         @mail_sender = 'nobody@nowhere.notld'
         @mail_contact = 'Nobody <nobody@nowhere.notld>'
         return
      end

      if @mail_test_receiver_enabled = hash['mail'].key?(:test_receiver)
         @mail_test_receiver = hash['mail']['test_receiver']
      end

      if not hash['mail'].key? :smtp
         @mail_delivery_method = [:sendmail]
         return
      end

      @mail_delivery_method = [:smtp, hash['mail']['smtp']]
      @mail_sender = "#{hash['mail']['sender_name']}"
      @mail_sender << " <#{hash['mail']['sender']}>"
   end
end
