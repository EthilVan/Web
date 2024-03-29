module EthilVan::App::Views

   module Base::Message

      class Edit < Page

         def initialize(discussion_urls, message, inline = false, url = '')
            @discussion_urls = discussion_urls
            @form = Partials::Message::Form.new(message, inline, url)
            @cadre = Partials::Account::Cadre.new(message.account)
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
