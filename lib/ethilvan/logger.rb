require 'logging'

module EthilVan

   module Logging

      def self.registered(app)
         app.helpers Helpers
      end

      def self.layout
         pattern = '[%d] %-5l: %m\n'
         if EthilVan.production?
            date_pattern = '%d/%m/%Y %H:%M:%S'
         else
            date_pattern = '%H:%M:%S'
         end
         ::Logging.layouts.pattern(
               pattern: pattern, date_pattern: date_pattern)
      end

      module Helpers

         def logger
            @logger ||= ::Logging.logger[self.class]
         end
      end

      ::Logging.logger.root.appenders = ::Logging.appenders.stdout(
            layout: layout)

      EthilVan.production? { ::Logging.logger.root.level = :warn }
   end

   extend EthilVan::Logging::Helpers
end
