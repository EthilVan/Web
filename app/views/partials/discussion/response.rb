module EthilVan::App::Views

   module Partials::Discussion

      class Response < Partial

         def initialize(discussion, new_messages)
            @discussion = discussion
            @new_messages = new_messages
         end

         def discussion_url
            urls::Member::Discussion.show(@discussion)
         end

         def response_url
            urls::Member::Discussion.respond(@discussion, @discussion.last_message.id)
         end

         def new_messages
            stats_max = MinecraftStats.maximum('version')
            @new_messages.map do |message|
               editable = modo? || message.editable_by?(@app.current_account)
               Partials::Message::Display.new(message, editable, stats_max)
            end
         end
      end
   end
end
