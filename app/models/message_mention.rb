class MessageMention < ActiveRecord::Base

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :message
   belongs_to :mentionner, class_name: 'Account'
   belongs_to :mentionned, class_name: 'Account'

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
