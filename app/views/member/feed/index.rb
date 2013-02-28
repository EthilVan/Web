module EthilVan::App::Views

   class Member::Feed

      class Index < Page

         def initialize(activities)
            @activities = activities
         end

         def activities
            @activities.map do |activity|
               hash = {}
               if activity.actor.nil?
                  hash[:actor] = "Quelqu'un"
               else
                  hash[:actor] = activity.actor.name
               end
               hash[:action] = activity.action
               hash[:subject_type] = activity.subject_type
               hash[:subject_id] = activity.subject_id
               hash[:date] = I18n.l activity.created_at
               hash
            end
         end
      end
   end
end
