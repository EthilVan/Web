class EthilVan::Mustache::Form

   class Field

      attr_reader :fieldset
      attr_reader :name
      attr_reader :errors
      attr_reader :validations
      attr_reader :id

      def initialize(fieldset, name, validations, errors, attributes)
         @fieldset    = fieldset
         @name        = name
         @validations = Array(validations) + Array(attributes[:validations])
         @errors      = errors

         @id = attributes[:id] || @name
      end

      def errors?
         not @errors.empty?
      end

      def field_name
         fieldset.field_name @name
      end

      def field_id
         fieldset.field_id @id
      end

      def validations
         return '' if @validations.empty?
         ' ' + @validations.map do |name, value|
            "data-#{name}=\"#{value}\""
         end * ' '
      end

      def label
         @fieldset.label_for @name
      end

      def hint?
         hint.present?
      end

      def hint
         @hint ||= @fieldset.l10n_for @name, :hint
      end
   end
end
