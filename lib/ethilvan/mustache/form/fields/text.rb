class EthilVan::Mustache::Form

   class Text < Field

      attr_reader :value, :type

      def initialize(fieldset, name, value, validations, errors, attributes)
         super(fieldset, name, validations, errors, attributes)
         @value = value
         @type = attributes[:type] || 'text'
      end

      def placeholder
         placeholder = fieldset.l10n_for(@name, :placeholder)
         placeholder.present? ? " placeholder=\"#{placeholder}\"" : ''
      end
   end
end
