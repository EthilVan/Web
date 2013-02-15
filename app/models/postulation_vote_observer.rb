class PostulationVoteObserver < ActiveRecord::Observer
=begin
   def after_create(vote)
      postulation = vote.postulation
      visitor = Visitor.where(name: postulation.minecraft_name)
      if vote.agreement_needed?
         agreements = postulation.agreements_needed.size
         if agreements >= PostulationVote.total_needed
            visitor.destroy_all
            postulation.update_attribute :status, 2
            Account.create_from_postulation(postulation)
            EthilVan.logger.info 'Sending final approbation mail'
         elsif agreements == 1
            visitor.first_or_create
            EthilVan.logger.info 'Sending first approbation mail'
         else
            EthilVan.logger.info 'Sending approbation mail'
         end
      elsif vote.refusal?
         postulation.update_attribute :status, 1
         EthilVan.logger.info 'Sending refusal mail'
      else
         EthilVan.logger.info 'Sending dummy approbation mail'
      end
   end
=end
end

ActiveRecord::Base.observers = PostulationVoteObserver
