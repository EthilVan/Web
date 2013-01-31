module EthilVan::Mustache

   class Form < Partial

      attr_reader :action, :method, :label_class, :field_class

      def initialize(action = '', method = 'POST')
         @action = action
         @method = method
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
   end
end

require 'ethilvan/mustache/model_form'
require 'ethilvan/mustache/form/field'
require 'ethilvan/mustache/form/text'
require 'ethilvan/mustache/form/checkbox'
require 'ethilvan/mustache/form/select'
