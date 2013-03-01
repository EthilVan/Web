class PostulationVoteObserver < ActiveRecord::Observer

   def after_create(vote)
      Activity.create_for(vote.account, 'create', postulation)
   end
end

ActiveRecord::Base.observers << PostulationVoteObserver
