module EthilVan

   class Markdown::Field < Mustache::Form::Text

      include Markdown::Helpers

      def initialize(*)
         super
         model = fieldset.model
         unless model.is_a? EthilVan::Markdown::ActiveRecord
            @parsed_field = nil
            return
         end
         @parsed_field = model.class.markdown_fields[name]
      end

      def parsed_value
         return markdown(value.nil? ? '' : value) if @parsed_field.nil?
         fieldset.model.send(@parsed_field)
      end
   end
end

class EthilVan::Mustache::Form

   module Fieldset

      def markdown_f(name, attributes = {})
         field(EthilVan::Markdown::Field, name, attributes)
      end
      alias :markdown :markdown_f
   end
end
