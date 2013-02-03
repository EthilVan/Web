module EthilVan::App::Views

   module Member::Discussion

      class Create < Page

         class Form < EthilVan::Mustache::Form

            class MessageFields < EthilVan::Mustache::Form::Association

               def contents
                  text :contents
               end
            end

            def initialize(discussion)
               super(discussion)
            end

            def name
               text :name
            end

            def first_message
               association MessageFields, :first_message
            end
         end

         def initialize(discussion)
            @form = Form.new(discussion)
         end

         def form
            @form
         end
      end
   end
end
