module EthilVan::App::Views

   module Member::Message

      class Create < Edit

         def initialize(new_messages, message, inline = false)
            last_message = message.discussion.last_message
            url = "/membre/discussion/#{message.discussion.id}/repondre"
            url << "/#{last_message.id}" unless last_message.nil?
            super(message, inline, url)
            @new_messages = new_messages
         end

         def new_messages
            return [] if @new_messages.empty?
            stats_max = MinecraftStats.maximum('version')
            @new_messages.map do |message|
               editable = modo? || message.editable_by?(@app.current_account)
               Partials::Message::Display.new(message, editable, stats_max)
            end
         end
      end
   end
end
