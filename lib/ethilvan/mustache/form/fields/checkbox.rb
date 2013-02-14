class EthilVan::Mustache::Form

   class Checkbox < Field

      def initialize(fieldset, name, value, errors, validation, attributes)
         super(fieldset, name, errors, validation, attributes)
         @value = value
      end

      def value
         val = ' value="1"'
         val += ' checked="checked"' if @value
         val
      end

      def custom_value
         @value ? ' checked' : ''
      end

      def checked_switch_value
         @value ? ' active' : ''
      end

      def switch_value
         @value ? '' : ' active'
      end
   end
end
