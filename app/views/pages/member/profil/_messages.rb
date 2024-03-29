module EthilVan::App::Views

   module Member::Profil

      class Messages < PageTab

         def initialize(page, account, messages)
            super(page, 'messages')
            @account = account
            @messages = messages
         end

         def messages
            index = -1
            @messages.map do |msg|
               index += 1
               Partials::Message::Display.new(urls::Member::Discussion::Urls, msg, index)
            end
         end
      end
   end
end
