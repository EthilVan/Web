class Activity < ActiveRecord::Base

   default_scope order('created_at DESC').includes(:subject)
         .includes(actor: [:profil])

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

   def self.feed(viewer, page = 1)
      filter(:feed, viewer, page(page).per(40))
   end

   def self.list(actor, viewer, page = 1)
      cond = Activity.arel_table[:subject_type].eq("Account")
      cond = cond.and(Activity.arel_table[:subject_id].eq(actor.id))
      cond = cond.or(Activity.arel_table[:actor_id].eq(actor.id))
      filter(:list, viewer, where(cond).page(page).per(40))
   end

   def self.count(actor, viewer)
      filter(:stat, viewer, where(actor_id: actor.id)).count
   end

   def self.filter(type, viewer, query)
      list = query.all
      list.select do |activity|
         subject = activity.subject
         next false if subject.nil?
         next true unless subject.class.is_a? Subject
         subject.class._activities_filters[type].all? do |filter|
            filter.apply(viewer, activity.action, subject)
         end
      end
   end
end
