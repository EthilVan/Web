module EthilVan::App::Views

   module Partials::Discussion

      class Display < Partial

         def initialize(discussion_urls, discussion, page = nil)
            @discussion_urls = discussion_urls
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
            not_archived = !@discussion.archived
            @page.each_with_index.map do |message, index|
               editable = modo?
               editable ||= not_archived && message.editable_by?(current_account)
               Partials::Message::Display.new(@discussion_urls, message, editable)
            end
         end

         def pager
            @pager ||= create_pager
         end

         def create_pager
            pager = Pager.new(@discussion_urls, @discussion, @page)
            pager.total > 1 ? pager : nil
         end

         def can_respond?
            modo? or not @discussion.archived?
         end

         def url
            @discussion_urls.discussion.show(@discussion_urls, @discussion)
         end

         def response_url
            if pager.nil? or pager.current == pager.total
               last_message = @discussion.last_message
            else
               last_message = nil
            end
            @discussion_urls.discussion.respond(@discussion, last_message)
         end

         def edit_url
            @discussion_urls.discussion.edit(@discussion)
         end

         def delete_url
            @discussion_urls.discussion.delete(@discussion)
         end
      end
   end
end
