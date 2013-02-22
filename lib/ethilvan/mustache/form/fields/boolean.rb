class EthilVan::Mustache::Form

   class Boolean < Field

      class TrueOption < Choice::Option

         def initialize(field, selected)
            super(field, selected, "1")
         end

         def value
            @value ||= l10n_value || 'Oui'
         end
      end

      class FalseOption < Choice::Option

         def initialize(field, selected)
            super(field, selected, "0")
         end

         def value
            @value ||= l10n_value || 'Non'
         end
      end

      def initialize(fieldset, name, value, validations, errors, attributes)
         super(fieldset, name, validations, errors, attributes)
         @value = ![nil, false, "0", "false"].include?(value)
         @true_option = TrueOption.new(self, @value)
         @false_option = FalseOption.new(self, !@value)
      end

      def among
         [@true_option, @false_option]
      end

      def selected
         @value ? @true_option : @false_option
      end

      def checkbox_trusy
         @true_option
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
