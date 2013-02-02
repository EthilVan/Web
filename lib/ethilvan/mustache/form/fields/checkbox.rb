class EthilVan::Mustache::Form

   class Checkbox < Field

      def initialize(fieldset, name, value, errors, validation, attributes)
         super(fieldset, name, errors, validation, attributes)
         @value = value
      end

      def value
         val = ' value="1"'
         val += ' checked' if @value
         val
      end
   end
end
