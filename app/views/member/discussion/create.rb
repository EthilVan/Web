module EthilVan::App::Views

   module Member::Discussion

      class Create < Page

         def initialize(discussion, message)
            @discussion = discussion
            @message = message
         end

         def name
            @discussion.name
         end

         def message
            @message.contents
         end
      end
   end
end
