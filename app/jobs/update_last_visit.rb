module EthilVan::Jobs

   class UpdateLastVisit

      def initialize(account, visit)
         @account_id = account.id
         @visit = visit
      end

      def run
         puts 'Updating Last Visit ...'
         account = Account.find_by_id @account_id
         account.update_attribute :last_visit, @visit
      end
   end
end
