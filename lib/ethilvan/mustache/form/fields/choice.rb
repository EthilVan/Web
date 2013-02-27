class EthilVan::Mustache::Form

   class Choice < Field

      class Option

         attr_reader :name

         def initialize(field, name, value = nil, selected)
            @field = field
            @name = name
            @selected = selected
            @value = value
         end

         def trusy?
            ![nil, false, "0", "false"].include?(name)
         end

         def l10n_value
            @field.fieldset.l10n_for(name, "choice", @field.name)
         end

         def value
            @value ||= l10n_value || name
         end

         def selected?
            @selected
         end

         def select_attribute
            selected? ? ' selected="selected"' : ''
         end

         def switch_class
            selected? ? ' active' : ''
         end
      end

      attr_reader :among

      def initialize(fieldset, name, selected, validations, errors, attributes)
         super(fieldset, name, validations, errors, attributes)

         @among = (attributes[:among] || []).map do |name, value|
            Option.new(self, name, value, selected.to_s == name.to_s)
         end
      end

      def selected
         @selected ||= @among.find(&:selected?) || @among.first
      end

      def trusy
         @trusy ||= @among.find(&:trusy?)
      end

      def checkbox_attribute
         trusy.selected? ? ' checked="checked"' : ''
      end

      def checkbox_class
         trusy.selected? ? ' checked' : ''
      end

      def checkbox_value
         trusy.value
      end

      def toggle_class
         trusy.selected? ? ' active' : ''
      end

      def toggle_value
         trusy.value
      end
   end
end
