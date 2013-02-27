class EthilVan::Mustache::Form

   class MultiChoice < Field

      class Option < Field

         def initialize(fieldset, name, selected, label, attributes)
            super(fieldset, name, {}, [], attributes)
            @selected = selected
            @label = label
         end

         def field_name
            @fieldset.compute_field_name ''
         end

         def label
            @label || super
         end

         def selected?
            @selected
         end

         def checkbox_attribute
            selected? ? ' checked="checked"' : ''
         end

         def checkbox_class
            selected? ? ' checked' : ''
         end

         def checkbox_value
            @name
         end

         def toggle_class
            selected? ? ' active' : ''
         end
      end

      include FieldContainer

      attr_reader :model, :among

      def initialize(fieldset, name, value, validations, errors, attributes)
         super(fieldset, name, validations, errors, attributes)
         @model = fieldset.model
         @among = (attributes[:among] || []).map do |option_value, label = nil|
            Option.new(self, option_value, value.include?(option_value), label, {})
         end
      end

      def field_names
         fieldset.field_names + [name]
      end

      def field_ids
         fieldset.field_ids + [name]
      end

      def i18n_namespaces
         fieldset.i18n_namespaces
      end
   end
end
