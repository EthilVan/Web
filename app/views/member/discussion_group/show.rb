module EthilVan::App::Views

   module Member::DiscussionGroup

      class Show < Page

         def initialize(group, views, limit = false)
            @group = group
            @views = views

            @discussions = @group.discussions
            @remaining = 0
            if limit
               @remaining = @discussions.size - limit
               @discussions = @discussions[0...5]
            end
         end

         def name
            @group.name
         end

         def description
            @group.description
         end

         def url
            "/membre/discussion/#{@group.url}"
         end

         def edit_url
            "#{url}/editer"
         end

         def delete_url
            "#{url}/supprimer"
         end

         def remaining?
            @remaining > 0
         end

         def remaining
            @remaining
         end

         def discussions?
            !@discussions.empty?
         end

         def discussions
            @discussions.map do |discussion|
               DiscussionPreview.new(discussion, @app.current_account, @views)
            end
         end
      end
   end
end
