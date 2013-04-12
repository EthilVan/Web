class MessageMentionObserver < ActiveRecord::Observer

   def after_create(mention)
      Activity.create_for(mention.mentionner, 'create', mention)
   end
end

ActiveRecord::Base.observers << MessageMentionObserver
