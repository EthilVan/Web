module EthilVan::App::Views

   module Member::DiscussionGroup

      class Show < Page

         def initialize(group, views, limit = false)
            @group = group
            @views = views
            @limit = limit
         end

         def meta_page_title
            "#{@group.name} | Discussions"
         end

         def group
            Partials::DiscussionGroup::Display.new(@group, @views, @limit)
         end
      end
   end
end
