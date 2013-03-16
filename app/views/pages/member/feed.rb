module EthilVan::App::Views

   class Member::Feed < Page

      module FeedActivity

         attr_writer :last_view

         def avatar?
            true
         end

         def last_view
            @last_view || Time.at(0)
         end

         def viewed?
            @model.created_at < last_view
         end

         def viewed_class
            viewed? ? 'viewed' : 'new'
         end
      end

      def initialize(activities, last_view)
         @activities = activities
         @last_view = last_view
      end

      def activities
         @activities.map do |model|
            activity = Member::Activity.for(model)
            activity.extend FeedActivity
            activity.last_view = @last_view
            activity
         end
      end
   end
end
