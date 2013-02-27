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

      def choice_f(name, attributes = {})
         field(Choice, name, attributes)
      end
      alias :choice :choice_f

      def boolean_f(name, attributes = {})
         field(Boolean, name, attributes)
      end
      alias :boolean :boolean_f

      def multichoice_f(name, attributes = {})
         field(MultiChoice, name, attributes)
      end
      alias :multichoice :multichoice_f

      def association(klass, name, attributes = {})
         reflection = @model.reflections[name]
         if !reflection.nil? and reflection.macro == :has_many
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
         errors = model.errors
         errors[name].map { |error| errors.full_message(name, error) }
      end
   end
end
