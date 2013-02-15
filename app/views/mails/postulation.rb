module EthilVan::App::Views

   class Mails::Postulation < Mail

      attr_accessor :remaining_agreement

      def initialize(postulation, vote)
         @vote = vote
         @postulation = postulation
         @remaining_agreement = nil
      end

      def receiver
         @postulation.email
      end

      def message?
         @vote.message.present?
      end

      def voter
         @vote.account.name
      end

      def message
         @vote.message
      end
   end
end
