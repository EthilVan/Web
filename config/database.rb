require 'active_record'

class ActiveRecord::Base
   EthilVan::Config['database'].each do |env, dbconfig|
      configurations[env.to_sym] = dbconfig
   end

   establish_connection configurations[EthilVan::ENV]
end
