# encoding: utf-8

#######################################################
# Configuration exemple :
# -------------------------------------------------
# ActiveRecord::Base.configurations[:development] = {
#   :adapter   => 'mysql2',
#   :encoding  => 'utf8',
#   :reconnect => true,
#   :pool      => 5,
#   :host      => 'localhost',
#   :database  => 'your_database',
#   :username  => 'root',
#   :password  => '',
# }
#

begin
  rrequire 'config/database.private'
rescue Exception => exc
  puts 'Configuration de la base données manquante !'
  puts '(Fichier config/database.private.rb)'
  exit 1
end

class ActiveRecord::Base
   establish_connection configurations[EthilVan::ENV]
end
