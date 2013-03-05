module EthilVan::App::Views

   module Member::Profil

      class Activities < PageTab

         def initialize(page, activities)
            super(page, 'activites')
            @activities = activities
         end

         def activities
            @activities.map { |model| Member::Activity.for(model) }
         end
      end
   end
end
