module EthilVan::Mustache

   class Form::Text < Form::Field

      attr_reader :value, :type

      def initialize(form, name, value = "", attributes = {})
         super(form, name, attributes)
         @value = value
         @type = attributes[:type] || 'text'
         @placeholder = attributes[:placeholder]
      end

      def placeholder
         @placeholder.present? ? " placeholder=\"#{@placeholder}\"" : ''
      end
   end
end
