module EthilVan::App::Views

   module Member::Profil

      class Messages < Partial

         def initialize(account, messages)
            @account = account
            @messages = messages
         end

         def messages
            index = 0
            @messages.map do |msg|
               wrapped = Member::Discussion::Message.new(msg, index)
               index += 1
               wrapped
            end
         end
      end
   end
end
