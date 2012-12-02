require_relative 'env'
require 'active_record'

class ActiveRecord::Base

   default_config = {
      'adapter'   => 'mysql2',
      'encoding'  => 'utf8',
      'reconnect' => true,
      'pool'      => 5,
      'host'      => 'localhost',
   }

   EthilVan::Config['database'].each do |env, dbconfig|
      configurations[env.to_sym] = default_config.merge(dbconfig)
   end

   establish_connection configurations[EthilVan::ENV]
end

require_all 'app/models'
