require_relative 'env'
require_relative 'urls'
require 'active_record'
require 'kaminari'

Kaminari::Hooks.init

class ActiveRecord::Base

   establish_connection EthilVan::Config.database
   self.logger = Logging.logger[self]
end

require_all 'app/models'
