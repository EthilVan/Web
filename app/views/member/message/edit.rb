module EthilVan::App::Views

   module Member::Message

      class Edit < Page

         def initialize(message, url = '')
            @form = Form.new(message, url)
         end

         def form
            @form
         end
      end
   end
end
