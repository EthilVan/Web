module EthilVan::App::Views

   module Gestion::Postulation

      class Vote < Partial

         def initialize(vote)
            @vote = vote
         end

         def account
            @vote.account.name
         end

         def agreement?
            @vote.agreement?
         end

         def agreement_needed?
            @vote.agreement_needed?
         end

         def agreement_class
            return 'vote-refus' unless agreement?
            return 'vote-approbation ' + agreement_subclass
         end

         def message?
            @vote.message.present?
         end

         def message
            @vote.message
         end

      private

         def agreement_subclass
            return 'vote-approbation-needed' if agreement_needed?
            'vote-approbation-not-needed'
         end
      end
   end
end
