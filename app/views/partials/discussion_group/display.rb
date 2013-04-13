module EthilVan::App::Views

   module Partials::DiscussionGroup

      class Display < Partial

         def initialize(group, views, limit = false)
            @group = group
            @views = views

            @discussions = @group.discussions
            @remaining = 0
            if limit
               @remaining = [0, @discussions.size - limit].max
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
            urls::Member::DiscussionGroup.show(@group)
         end

         def edit_url
            urls::Member::DiscussionGroup.edit(@group)
         end

         def delete_url
            urls::Member::DiscussionGroup.delete(@group)
         end

         def icon?
            icon.present?
         end

         def icon
            @group.icon
         end

         def remaining_or_archived?
            @remaining > 0 or archived?
         end

         def archived?
            archived > 0
         end

         def remaining
            @remaining + archived
         end

         def archived
            _archived_discussions.size
         end

         def archived_plural?
            archived > 1
         end

         def discussions?
            !@discussions.empty?
         end

         def discussions
            @discussions.map do |discussion|
               Partials::Discussion::Preview.new(discussion,
                     @app.current_account, @views)
            end
         end

         def archived_discussions?
            !_archived_discussions.empty?
         end

         def archived_discussions
            _archived_discussions.map do |discussion|
               Partials::Discussion::Preview.new(discussion,
                     @app.current_account, @views)
            end
         end

      private

         def _archived_discussions
            @archived_discussions ||= @group.archived_discussions
         end
      end
   end
end
