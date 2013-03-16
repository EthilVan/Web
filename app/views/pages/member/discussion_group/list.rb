module EthilVan::App::Views

   module Member::DiscussionGroup

      class List < Page

         def initialize(groups, views)
            @groups = groups
            @views = views
         end

         def groups?
            !@groups.empty?
         end

         def groups
            @groups.map do |group|
               Partials::DiscussionGroup::Display.new(group, @views, 5)
            end
         end
      end
   end
end
