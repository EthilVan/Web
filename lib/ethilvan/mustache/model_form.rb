module EthilVan::Mustache

   class ModelForm < Form

      def initialize(model, base_name = nil, action = '', method = 'POST')
         @base_name = base_name || model.class.model_name.param_key
         super(action, method)
         @model = model
      end

      def text(name, attributes = {})
         extract_base_data(attributes, name)
         extract_i18n_data(attributes, name, :placeholder)
         super(field_name(name), value_for(name), attributes)
      end

      def checkbox(name, attributes = {})
         extract_base_data(attributes, name)
         super(field_name(name), value_for(name), attributes)
      end

      def select(name, among, attributes = {})
         extract_base_data(attributes, name)
         super(field_name(name), value_for(name), among, attributes)
      end

      def field_name(name)
         "#@base_name[#{name}]"
      end

      def field_id(name)
         "#{@base_name}_#{name}"
      end

   private

      def value_for(name)
         @model.send name
      end

      def extract_base_data(attributes, name)
         attributes[:id] ||= field_id(name)
         errors = @model.errors
         attributes[:errors] ||= []
         attributes[:errors] += errors[name].map do |message|
            errors.full_message(name, message)
         end

         extract_i18n_data(attributes, :label, name)
         attributes[:label] ||= @model.class.human_attribute_name(name)
         extract_i18n_data(attributes, :hint, name)
      end

      def extract_i18n_data(attributes, field_name, data_name)
         return if attributes.key? data_name
         data = i18n_data(data_name, field_name)
         attributes[data_name] = data unless data.nil?
      end

      def i18n_data(field_name, data_name)
         key = [
            "form", @model.class.model_name.i18n_key,
            data_name, field_name
         ] * '.'
         I18n.translate! key
      rescue I18n::MissingTranslationData
         nil
      end
   end
end
