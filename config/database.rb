# encoding: utf-8

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
