class MessageMention < ActiveRecord::Base

   include Activity::Subject

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :message
   belongs_to :mentionner, class_name: 'Account'
   belongs_to :mentionned, class_name: 'Account'

   # ==========================================================================
   # * Activity
   # ==========================================================================
   activities_includes message: :discussion, mentionned: []

   activities_filter :feed, :create do |viewer, subject, activity|
      [activity.actor.id, subject.mentionned.id].include? viewer.id
   end

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def self.create_for(message, account)
      mention = new
      mention.message = message
      mention.mentionner = message.account
      mention.mentionned = account
      mention.save
   end
end
