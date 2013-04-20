module EthilVan::App::Views

   module Partials::Discussion

      class Response < Partial

         def initialize(discussion_urls, discussion, new_messages)
            @discussion_urls = discussion_urls
            @discussion = discussion
            @new_messages = new_messages
         end

         def discussion_url
            @discussion_urls.discussion.show(@discussion)
         end

         def response_url
            @discussion_urls.discussion.respond(@discussion, @discussion.last_message)
         end

         def new_messages
            stats_max = MinecraftStats.maximum('version')
            @new_messages.map do |message|
               editable = modo? || message.editable_by?(@app.current_account)
               Partials::Message::Display.new(@discussion_urls, message, editable)
            end
         end
      end
   end
end
