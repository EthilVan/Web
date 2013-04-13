module EthilVan

   module Url::Member

      extend self

      BASE = '/membre'

      def feed
         BASE + '/apropos'
      end

      def members
         BASE + '/list'
      end
   end
end
