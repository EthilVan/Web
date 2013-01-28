module EthilVan::App::Views

   module Member::Profil

      class Messages < Partial

         def initialize(account, messages)
            @account = account
            @messages = messages
         end

         def messages
            index = -1
            @messages.map do |msg|
               index += 1
               Member::Discussion::Message.new(msg, index)
            end
         end
      end
   end
end
