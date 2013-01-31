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
      end

      def label_class
         @form.label_class
      end

      def field_class
         @form.field_class
      end

      def errors?
         @errors.present?
      end

      def hint?
         @hint.present?
      end
   end
end
