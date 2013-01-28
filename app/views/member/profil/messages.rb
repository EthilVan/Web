module EthilVan::App::Views

   module Member::Profil

      class Messages < Partial

         def initialize(account, messages)
            @account = account
            @messages = messages
         end

         def count
            @messages.size
         end
      end
   end
end
