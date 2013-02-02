module EthilVan::Mustache

   class Form < Partial

      attr_reader :label_class, :field_class

      def initialize(attributes = {})
         @action = attributes[:action] || ''
         @method = attributes[:method] || 'POST'
         @validation = attributes[:validation] || 'parsley'
      end

      def attributes
         attrs = "method=\"#@method\" action=\"#@action\""
         attrs << validation_attributes
         attrs
      end

      def label_common_class
         lambda { |_class| @label_class = _class; nil }
      end

      def text(*args)
         Text.new(self, *args)
      end

      def checkbox(*args)
         Checkbox.new(self, *args)
      end

      def select(*args)
         Select.new(self, *args)
      end

   private

      def validation_attributes
         if @validation == "parsley"
            return " novalidate data-validate=\"parsley\""
         end
         ''
      end
   end
end

require 'ethilvan/mustache/model_form'
require 'ethilvan/mustache/form/field'
require 'ethilvan/mustache/form/text'
require 'ethilvan/mustache/form/checkbox'
require 'ethilvan/mustache/form/select'
