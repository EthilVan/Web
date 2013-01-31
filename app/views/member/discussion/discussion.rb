module EthilVan::App::Views

   module Member::Discussion

      class Discussion < Page

         def initialize(discussion, page = nil)
            @discussion = discussion
            @page = page
         end

         def name
            @discussion.name
         end

         def date
            I18n.l @discussion.created_at
         end

         def author
            _messages.first.account.name
         end

         def messages
            return [] if @page.nil?
            stats_max = MinecraftStats.maximum('version')
            @page.each_with_index.map do |message, index|
               account = @app.current_account
               if message.editable_by? account
                  EditableMessage.new(message, index, stats_max)
               else
                  DiscussionMessage.new(message, index, stats_max)
               end
            end
         end

         def pager
            @pager ||= create_pager
         end

         def create_pager
            pager = Pager.new(@discussion, @page)
            pager.total > 1 ? pager : false
         end

         def response_link
            "/membre/discussion/#{@discussion.id}/repondre"
         end

      private

         def _messages
            @messages ||= @discussion.messages
         end
      end
   end
end
