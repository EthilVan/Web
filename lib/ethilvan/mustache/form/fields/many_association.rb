class EthilVan::Mustache::Form

   class ManyAssociation < Field

      include FieldContainer

      attr_reader  :model
      attr_reader  :field_names
      alias_method :field_ids, :field_names
      attr_reader  :i18n_namespaces
      attr_reader  :values

      def initialize(fieldset, name, value, klass, validations, errors, attributes)
         super(self, name, validations, errors, attributes)
         @model = fieldset.model
         @field_names = fieldset.field_names + ["#{name}_attributes"]
         @i18n_namespaces = [@model.class.model_name.i18n_key] +
            fieldset.i18n_namespaces

         @values = value.map do |val|
            klass.new(self, '', val, validations, errors, attributes)
         end
      end
   end
end
