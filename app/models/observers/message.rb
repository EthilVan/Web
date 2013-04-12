class MessageObserver < ActiveRecord::Observer

   def after_create(message)
      unless message.first?
         Activity.create_for(message.account, 'create', message)
      end

      message.parsed_mentions.each do |mention|
         MessageMention.create_for(message, mention)
      end
   end

   def after_update(message)
      contents_before = message.parsed_contents_was
      contents_after  = message.parsed_contents
      if contents_before != contents_after
         Activity.create_for(message.activity_actor, 'edit', message)
      end
   end

   def after_destroy(message)
      Activity.create_for(message.activity_actor, 'deleted', nil)
   end
end

ActiveRecord::Base.observers << MessageObserver
