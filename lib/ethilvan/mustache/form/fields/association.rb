class EthilVan::Mustache::Form

   class Association < Field

      include Fieldset

      attr_reader  :model
      attr_reader  :value
      attr_reader  :field_names
      attr_reader  :field_ids
      attr_reader  :i18n_namespaces
      attr_reader  :index

      def initialize(fieldset, name, value, errors, validation, attributes)
         super(fieldset, name, errors, validation, attributes)
         @model = value
         @field_names = fieldset.field_names
         @field_names += [name.blank? ? '' : "#{name}_attributes"]
         @field_ids = fieldset.field_ids + [id]
         @i18n_namespaces = [@model.class.model_name.i18n_key] +
               fieldset.i18n_namespaces
         @index = attributes[:id] || 1
      end
   end
end
