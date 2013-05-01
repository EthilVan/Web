module EthilVan::Jobs

   class UpdateFeedView

      def initialize(account, view)
         @account_id = account.id
         @view = view
      end

      def message
         'Updating Feed View ...'
      end

      def run
         account = Account.find_by_id @account_id
         account.update_attribute :feed_view, @view
      end
   end
end
