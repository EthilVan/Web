module EthilVan::Mustache

   class Form::Field < Partial

      attr_reader :name, :id, :label, :errors, :hint

      def initialize(form, name, attributes = {})
         @form = form
         @name = name
         @id = attributes[:id] || name
         @label = attributes[:label]
         @errors = attributes[:errors]
         @hint = attributes[:hint]
         @validations = attributes[:validations] || {}
      end

      def label_class
         @form.label_class
      end

      def field_class
         @form.field_class
      end

      def validations
         return '' if @validations.empty?
         ' ' + @validations.map do |name, value|
            "data-#{name}=\"#{value}\""
         end * ' '
      end

      def errors?
         @errors.present?
      end

      def hint?
         @hint.present?
      end
   end
end
