module EthilVan::App::Views

   module Member::Message

      class Create < Page

         def initialize(message)
            @form = Form.new(message)
         end

         def form
            @form
         end
      end
   end
end
