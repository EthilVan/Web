module EthilVan::App::Views

   module Member::Discussion

      class Response < Member::Discussion::Message

         def initialize(discussion, *args)
            super(*args)
            @discussion = discussion
         end

         def discussion_url
            "/membre/discussion/#{@discussion.id}"
         end

         def response_url
            "#{discussion_url}/repondre/enplace"
         end
      end
   end
end
