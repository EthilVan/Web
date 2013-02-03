module EthilVan::App::Views

   module Member::Message

      class Edit < Page

         def initialize(message, url = '')
            @form = Form.new(message, url)
            @cadre = Cadre.new(message.account)
         end

         def cadre
            @cadre
         end

         def form
            @form
         end
      end

      class Create < Edit
      end
   end
end
