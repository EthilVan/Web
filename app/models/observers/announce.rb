class AnnounceObserver < ActiveRecord::Observer

   def after_create(announce)
      Activity.create_for(announce.account, 'create', announce)
   end
end

ActiveRecord::Base.observers << AnnounceObserver
