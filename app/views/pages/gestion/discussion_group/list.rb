module EthilVan::App::Views

   module Gestion::DiscussionGroup

      class List < Page

         def initialize(discussion_urls, groups, views)
            @discussion_urls = discussion_urls
            @groups = groups
            @views = views
         end

         def groups?
            !@groups.empty?
         end

         def groups
            @groups.map do |group|
               Partials::DiscussionGroup::Display.new(@discussion_urls, group, @views, 5)
            end
         end
      end
   end
end
