module EthilVan::Markdown::ActiveRecord

   extend ActiveSupport::Concern

   included do
      include EthilVan::Markdown::Helpers
   end

   module ClassMethods

      def markdown_pre_parse(field, parsed_field = "parsed_#{field}")
         self.class_eval(<<-EVAL)
            def #{field}=(new_value)
               write_attribute :#{field}, new_value
               write_attribute :#{parsed_field}, nil
            end

         private

            def new_#{field}?
               !#{field}.nil? and #{parsed_field}.nil?
            end

            def parse_#{field}
               self.#{parsed_field} = markdown(#{field})
            end
         EVAL
         before_save :"parse_#{field}", if: :"new_#{field}?"
      end
   end
end
