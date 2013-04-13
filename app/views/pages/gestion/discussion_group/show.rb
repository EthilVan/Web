module EthilVan::App::Views

   module Gestion::DiscussionGroup

      class Show < Page

         def initialize(discussion_urls, group, views, limit = false)
            @discussion_urls = discussion_urls
            @group = group
            @views = views
            @limit = limit
         end

         def meta_page_title
            "#{@group.name} | Discussions"
         end

         def group
            Partials::DiscussionGroup::Display.new(@discussion_urls, @group, @views, @limit)
         end
      end
   end
end
