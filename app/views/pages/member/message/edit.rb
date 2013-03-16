module EthilVan::App::Views

   module Member::Message

      class Edit < Page

         def initialize(message, inline = false, url = '')
            @form = Partials::Message::Form.new(message, inline, url)
            @cadre = Partials::Message::Cadre.new(message.account)
         end

         def cadre
            @cadre
         end

         def form
            @form
         end
      end
   end
end
