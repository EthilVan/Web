module EthilVan::App::Views

   module Member::DiscussionGroup

      class DiscussionPreview < ArchivedDiscussionPreview

         def initialize(discussion, current_account, views)
            super(discussion, current_account)
            @viewed = viewed? views
         end

         def status_class
            @viewed ? super : 'unread'
         end

      private

         def viewed?(views)
            view = views[nil]
            return true if !view.nil? and view.first > @discussion
            view = views[@discussion.id]
            return (!view.nil? and view.first > @discussion)
         end
      end
   end
 end
