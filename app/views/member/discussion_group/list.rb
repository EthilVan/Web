module EthilVan::App::Views

   module Member::DiscussionGroup

      class List < Page

         def initialize(groups)
            @groups = groups
         end

         def groups?
            !@groups.empty?
         end

         def groups
            @groups.map { |group| Show.new(group, 5) }
         end
      end
   end
end
