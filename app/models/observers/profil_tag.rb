class ProfilTagObserver < ActiveRecord::Observer

   def after_create(tag)
      Activity.create_for(tag.tagger, 'create', tag)
   end
end

ActiveRecord::Base.observers << ProfilTagObserver
