module EthilVan::Markdown::ActiveRecord

   extend ActiveSupport::Concern

   included do
      include EthilVan::Markdown::Helpers
      @markdown_fields = {}
   end

   module ClassMethods

      attr_reader :markdown_fields

      def markdown_pre_parse(field, parsed_field = "parsed_#{field}")
         @markdown_fields[field] = parsed_field
         self.class_eval(<<-EVAL)
            def #{field}=(new_value)
               markdown_set(:#{field}, :#{parsed_field}, new_value)
            end

         private

            def new_#{field}?
               markdown_new?(:#{field}, :#{parsed_field})
            end

            def parse_#{field}
               markdown_parse(:#{field}, :#{parsed_field})
            end
         EVAL
         before_save :"parse_#{field}", if: :"new_#{field}?"
      end
   end

   def markdown_set(field, parsed_field, new_value)
      write_attribute(field, new_value)
      write_attribute(parsed_field, nil)
   end

   def markdown_new?(field, parsed_field)
      !read_attribute(field).nil? and read_attribute(parsed_field).nil?
   end

   def markdown_parse(field, parsed_field)
      parsed_value = markdown read_attribute field
      write_attribute(parsed_field, parsed_value)
   end
end
