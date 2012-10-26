module EthilVan::Mustache

   module Form

      def field(value)
         return '' if value.nil?
         return "value=\"#{escapeHTML value}\" "
      end

      def checkbox(value)
         return 'value="1" ' unless value
         return "value=\"1\" checked=\"checked\" "
      end
   end
end
