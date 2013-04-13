module EthilVan::App::Views

   module Partials::Discussion

      class Display < Partial

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
            @discussion.author.name
         end

         def messages
            return [] if @page.nil?
            stats_max = MinecraftStats.maximum('version')
            not_archived = !@discussion.archived
            @page.each_with_index.map do |message, index|
               editable = modo?
               editable ||= not_archived && message.editable_by?(current_account)
               Partials::Message::Display.new(message, editable, stats_max)
            end
         end

         def pager
            @pager ||= create_pager
         end

         def create_pager
            pager = Pager.new(@discussion, @page)
            pager.total > 1 ? pager : nil
         end

         def can_respond?
            modo? or not @discussion.archived?
         end

         def url
            urls::Member::Discussion.show(@discussion)
         end

         def response_url
            if pager.nil? or pager.current == pager.total
               last_message = @discussion.last_message
            else
               last_message = nil
            end
            urls::Member::Discussion.respond(@discussion, last_message)
         end

         def edit_url
            urls::Member::Discussion.edit(@discussion)
         end

         def delete_url
            urls::Member::Discussion.delete(@discussion)
         end
      end
   end
end
