module EthilVan::App::Views

   module Member::Message

      class Edit < Page

         def initialize(message)
            @form = Form.new(message)
         end

         def form
            @form
         end
      end
   end
end
