require 'yaml'

class EthilVan::YamlConfig

   attr :database
   attr :mail_delivery_method
   attr :mail_sender
   attr :mail_contact

   def initialize(path)
      hash = YAML.load_file path
      load_database(hash)
      load_mail(hash)
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

      @mail_delivery_method = [:smtp, hash['mail']['smtp']]
      @mail_sender = "#{hash['mail']['sender_name']}"
      @mail_sender << " <#{hash['mail']['sender']}>"
      @mail_contact = hash['mail']['contact']
   end
end
