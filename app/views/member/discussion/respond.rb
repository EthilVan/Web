module EthilVan::App::Views

   module Member::Discussion

      class MessageForm < Page

         def initialize(message = ::Message.new)
            @message = message
         end

         def message
            @message.contents
         end
      end
   end
end
