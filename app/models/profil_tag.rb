class ProfilTag < ActiveRecord::Base

   include Activity::Subject

   attr_accessible :content

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :tagger, class_name: 'Account'
   belongs_to :tagged, class_name: 'Account'

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_length_of :content, within: 2..300
   validate :tagger_is_not_tagged

   # ==========================================================================
   # * Activity
   # ==========================================================================
   activities_includes :tagged
   activities_filter :feed, :create do |viewer, subject, activity|
      [activity.actor.id, subject.tagged.id].include? viewer.id
   end

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def tagger_is_not_tagged
      errors.add(:tagger, :invalid) if tagger_id == tagged_id
   end
end
