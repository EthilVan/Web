module EthilVan::App::Views

   class Member::Feed

      class Index < Page

         def initialize(activities)
            @activities = activities
         end

         def activities
            @activities.map { |model| Member::Activity.for(model) }
         end
      end
   end
end
