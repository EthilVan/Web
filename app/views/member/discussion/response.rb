module EthilVan::App::Views

   module Member::Discussion

      class Response < Page

         def initialize(message = ::Message.new)
            @message = message
         end

         def message
            @message.contents
         end
      end
   end
end
