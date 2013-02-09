module EthilVan::App::Views

   module Member::Message

      class Edit < Page

         def initialize(message, inline = false, url = '')
            @form = Form.new(message, inline, url)
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
