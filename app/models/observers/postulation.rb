class PostulationObserver < ActiveRecord::Observer

   def after_create(postulation)
      Activity.create_for(nil, 'create', postulation)
   end
end

ActiveRecord::Base.observers << PostulationObserver
