class EthilVan::Mustache::Form

   module Fieldset

      include FieldContainer

      def text_f(name, attributes = {})
         field(Text, name, attributes)
      end
      alias :text :text_f

      def password_f(name, attributes = {})
         text(name, { type: :password }.merge(attributes))
      end
      alias :password :password_f

      def checkbox_f(name, attributes = {})
         field(Checkbox, name, attributes)
      end
      alias :checkbox :checkbox_f

      def select_f(name, attributes = {})
         field(Select, name, attributes)
      end
      alias :select :select_f

      def association(klass, name, attributes = {})
         reflection = @model.reflections[name]
         if reflection.macro == :has_many
            ManyAssociation.new(self, name, value_for(name), klass, validations_for(name),
               errors_for(name), attributes)
         else
            field(klass, name, attributes)
         end
      end

   private

      def field(klass, name, attributes)
         klass.new(self, name, value_for(name), validations_for(name),
               errors_for(name), attributes)
      end

      def value_for(name)
         model.send(name)
      end

      def validations_for(name)
         nil
      end

      def errors_for(name)
         model.errors[name]
      end

      def _l10n_for(ns, field, data)
         I18n.translate!(["form", ns, data, field] * '.')
      rescue I18n::MissingTranslationData
         nil
      end
   end
end
