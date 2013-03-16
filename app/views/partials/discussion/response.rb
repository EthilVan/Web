module EthilVan::App::Views

   module Partials::Discussion

      class Response < Partial

         def initialize(discussion, new_messages)
            @discussion = discussion
            @new_messages = new_messages
         end

         def discussion_url
            "/membre/discussion/#{@discussion.id}"
         end

         def response_url
            "#{discussion_url}/repondre/#{@discussion.last_message.id}"
         end

         def new_messages
            stats_max = MinecraftStats.maximum('version')
            @new_messages.map do |message|
               editable = modo? || message.editable_by?(@app.current_account)
               Member::Discussion::Message.new(message, editable, stats_max)
            end
         end
      end
   end
end
