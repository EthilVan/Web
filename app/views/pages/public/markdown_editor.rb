module EthilVan::App::Views

   module Public

      class MarkdownEditor < Page

         def field_id
            "markdown-draft-editor"
         end

         def field_name
            field_id
         end

         def validations
            nil
         end

         def value
            nil
         end

         def parsed_value
            nil
         end
      end
   end
end
