class EthilVan::Mustache::Form

   class Switch < Field

      def initialize(fieldset, name, value, errors, validation, attributes)
         super(fieldset, name, errors, validation, attributes)
         @value = value
      end

      def value
         @value ? '1' : '0'
      end

      def checked_switch_value
         @value ? ' active' : ''
      end

      def switch_value
         @value ? '' : ' active'
      end
   end
end
