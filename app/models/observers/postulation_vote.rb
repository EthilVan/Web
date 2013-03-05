class PostulationVoteObserver < ActiveRecord::Observer

   def after_create(vote)
      Activity.create_for(vote.account, 'create', vote)
   end
end

ActiveRecord::Base.observers << PostulationVoteObserver
