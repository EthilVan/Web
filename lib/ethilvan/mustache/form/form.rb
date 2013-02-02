module EthilVan::Mustache

   class Form < Partial

      include Fieldset

      attr_reader :model
      attr_reader :name

      def initialize(model, params = {})
         @model = model
         @name = model.class.model_name.param_key

         @id         = params[:id]         || @name
         @method     = params[:method]     || 'POST'
         @action     = params[:action]     || ''
         @validation = params[:validation] || 'parsley'
      end

      def attributes
         "method=\"#@method\" action=\"#@action\"#{validation_attributes}"
      end

      def field_names
         [@name]
      end

      def field_ids
         [@id]
      end

      def i18n_namespaces
         [@model.class.model_name.i18n_key]
      end

   private

      def validation_attributes
         return '' if @validation == 'html5'
         return ' novalidate' if ['false', 'nil'].include? @validation.to_s
         " novalidate data-validate=\"#@validation\""
      end
   end
end
