module EthilVan::Mustache

   class Form::Checkbox < Form::Field

      def initialize(form, name, value = false, attributes = {})
         super(form, name, attributes)
         @value = value
      end

      def value
         val = ' value="1"'
         val += ' checked' if @value
         val
      end
   end
end
