class EthilVan::Mustache::Form

   class Choice < Field

      class Option

         attr_reader :name

         def initialize(field, selected, name, value = nil)
            @field = field
            @name = name
            @selected = selected
            @value = value
         end

         def trusy?
            ![nil, false, "0", "false"].include?(name)
         end

         def l10n_value
            @field.fieldset.l10n_for(@field.name, "choice.#{name}")
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
            Option.new(self, selected.to_s == name.to_s, name, value)
         end
      end

      def selected
         @selected ||= @among.first(&:selected) || @among.first
      end

      def checkbox_trusy
         @checkbox_trusy ||= @among.first(&:trusy?)
      end

      def checkbox_attribute
         checkbox_trusy.selected? ? ' checked="checked"' : ''
      end

      def checkbox_class
         checkbox_trusy.selected? ? ' checked' : ''
      end

      def toggle_class
         checkbox_trusy.selected? ? ' active' : ''
      end

      def toggle_value
         checkbox_trusy.value
      end
   end
end
