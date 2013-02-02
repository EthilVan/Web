class EthilVan::Mustache::Form

   class ManyAssociation < Field

      include FieldContainer

      attr_reader  :model
      attr_reader  :field_names
      alias_method :field_ids, :field_names
      attr_reader  :i18n_namespaces

      attr_reader  :template
      attr_reader  :values

      def initialize(fieldset, name, value, klass, validations, errors,
            attributes)
         super(self, name, validations, errors, attributes)
         @model = fieldset.model
         @field_names = fieldset.field_names + ["#{name}_attributes"]
         @field_ids = fieldset.field_ids + [id]
         @i18n_namespaces = [@model.class.model_name.i18n_key] +
            fieldset.i18n_namespaces

         @template = nil
         if klass.respond_to? :model_template
            @template = klass.new(self, '', klass.model_template,
                  nil, [], { id: '%%template%%' })
         end
         @values = value.each_with_index.map do |val, index|
            attrs = { id: index + 1 }.merge(attributes)
            klass.new(self, '', val, validations, errors, attrs)
         end
      end
   end
end
