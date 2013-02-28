class Activity < ActiveRecord::Base

   default_scope order('created_at DESC').includes(:subject)
         .includes(:actor)

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :subject, polymorphic: true
   belongs_to :actor, class_name: 'Account'

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def self.create_for(actor, action, subject, data = nil)
      activity = new
      activity.subject = subject
      activity.action = action
      activity.actor = actor
      activity.data = data unless data.nil?
      activity.save
      activity
   end

   def self.feed(viewer)
      filter(:feed, viewer, self)
   end

   def self.list(actor, viewer)
      filter(:list, viewer, where(actor_id: actor.id))
   end

   def self.filter(type, viewer, query)
      query.all.select do |activity|
         subject = activity.subject
         next false if subject.nil?
         next true unless subject.class.is_a? Subject
         subject.class._activities_filters[type].all? do |filter|
            filter.apply(viewer, activity.action, subject)
         end
      end
   end
end
