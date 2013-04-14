class Activity < ActiveRecord::Base

   default_scope order('created_at DESC, id DESC').includes(:subject)
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

      subject_by_class = list.map(&:subject).group_by(&:class)
      subject_by_class.each do |klass, subjects|
         next unless klass.include? Subject
         klass._activities_includes.each do |includes|
            preloader = ActiveRecord::Associations::Preloader.new(subjects,
                  includes)
            preloader.run
         end
      end

      list.select do |activity|
         subject = activity.subject
         next false if subject.nil?
         next true unless subject.is_a? Subject
         filters = subject.class._activities_filters[type]
         next true if filters.nil?
         filters.all? do |filter|
            filter.apply(viewer, activity)
         end
      end
   end

   def viewer_is_actor?(viewer)
      actor_id == viewer.id
   end
end
