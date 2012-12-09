# encoding: utf-8

module EthilVan::App::Views

   module Member::Discussion

      class Discussion < Page

         def initialize(discussion)
            @discussion = discussion
         end

         def name
            @discussion.name
         end

         def date
            @discussion.created_at.strftime("%d/%m/%Y à %H:%M")
         end

         def author
            _messages.first.account.name
         end

         def messages
            base_url = "/membre/discussion/#{@discussion.id}"
            _messages.each_with_index.map do |message, index|
               account = @app.current_account
               if account.role.inherit? EthilVan::Role::MODO or message.account == account
                  EditableMessage.new(message, index, base_url)
               else
                  Message.new(message, index)
               end
            end
         end

         def response_link
            "/membre/discussion/#{@discussion.id}/reponse"
         end

      private

         def _messages
            @messages ||= @discussion.messages
         end
      end
   end
end
