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
            "/membre/discussion/#{@discussion.id}"
         end

         def response_url
            _url = "#{url}/repondre"
            if pager.nil? or pager.current == pager.total
               _url << "/#{@discussion.last_message.id.to_s}"
            end
            _url
         end

         def edit_url
            "#{url}/editer"
         end

         def delete_url
            "#{url}/supprimer"
         end
      end
   end
end
