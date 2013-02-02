class EthilVan::Mustache::Form

   class Association < Field

      include Fieldset

      attr_reader  :model
      attr_reader  :value
      attr_reader  :field_names
      alias_method :field_ids, :field_names
      attr_reader  :i18n_namespaces

      def initialize(fieldset, name, value, errors, validation, attributes)
         super(fieldset, name, errors, validation, attributes)
         @model = value
         @field_names = fieldset.field_names
         @field_names += [name.blank? ? '' : "#{name}_attributes"]
         @i18n_namespaces = [@model.class.model_name.i18n_key] +
               fieldset.i18n_namespaces
      end
   end
end
