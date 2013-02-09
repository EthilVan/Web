module EthilVan::App::Views

   module Member::Discussion

      class Show < Page

         def initialize(discussion, page = nil)
            @discussion = discussion
            @page = page
         end

         def page_title?
            false
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
            @page.each_with_index.map do |message, index|
               editable = modo? || message.editable_by?(@app.current_account)
               Message.new(message, index, editable, stats_max)
            end
         end

         def pager
            @pager ||= create_pager
         end

         def create_pager
            pager = Pager.new(@discussion, @page)
            pager.total > 1 ? pager : false
         end

         def url
            "/membre/discussion/#{@discussion.id}"
         end

         def response_url
            "#{url}/repondre"
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
