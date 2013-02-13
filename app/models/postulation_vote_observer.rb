class PostulationVoteObserver < ActiveRecord::Observer

   def after_create(vote)
      postulation = vote.postulation
      if vote.agreement_needed?
         agreements = postulation.agreements_needed.size
         if agreements >= PostulationVote.total_needed
            postulation.update_attribute :status, 2
            Account.create_from_postulation(postulation)
            EthilVan.logger.info 'Sending final approbation mail'
         else
            EthilVan.logger.info 'Sending approbation mail'
         end
      elsif vote.refusal?
         postulation.update_attribute :status, 1
         EthilVan.logger.info 'Sending refusal mail'
      end
   end
end

# ActiveRecord::Base.add_observer PostulationVoteObserver.instance
ActiveRecord::Base.observers = PostulationVoteObserver
