module EthilVan::App::Views

   module Member::Discussion

      class Index < Page

         def initialize(groups)
            @groups = groups
         end

         def groups?
            !@groups.empty?
         end

         def groups
            @groups.map { |group| DiscussionGroup.new(group, 5) }
         end
      end
   end
end
