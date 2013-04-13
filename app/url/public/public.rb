module EthilVan

   module Url::Public

      extend self

      def about
         'apropos'
      end

      def humanstxt
         '/humans.txt'
      end

      def login
         '/login'
      end

      def markdown
         '/markdown'
      end

      def markdown_members
         '/markdown/membres.json'
      end

      def postulation
         '/postulation'
      end

      def contact
         '/contact'
      end
   end
end
