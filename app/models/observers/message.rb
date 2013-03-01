class MessageObserver < ActiveRecord::Observer
=begin
   def after_create(message)
      Activity.create_for(message.account, 'create', message)
   end

   def after_update(message)
      contents_before = message.parsed_contents_was
      contents_after  = message.parsed_contents
      if contents_before != contents_after
         Activity.create_for(message.activity_actor, 'edit', message)
      end
   end
=end
end

ActiveRecord::Base.observers << MessageObserver
