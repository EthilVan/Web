require 'logging'

module EthilVan

   pattern = '[%d] %-5l: %m\n'
   date_pattern = production? ? '%d/%m/%Y %H:%M:%S' : '%H:%M:%S'
   layout = ::Logging.layouts.pattern(
         pattern: pattern, date_pattern: date_pattern)

   ::Logging.logger.root.appenders = Logging.appenders.stdout(
         layout: layout)

   module Logging

      def self.registered(app)
         app.helpers Helpers
      end

      module Helpers

         def logger
            @logger ||= ::Logging.logger[self.class]
         end
      end
   end
end
