module EthilVan::Jobs

   class UpdateDiscussionView

      def initialize(account, discussion, view)
         @account_id = account.id
         @discussion_id = discussion.id
         @view = view
      end

      def message
         'Updating Discussion View ...'
      end

      def run
         DiscussionView.update_for(@account_id, @discussion_id, @view)
      end
   end
end
