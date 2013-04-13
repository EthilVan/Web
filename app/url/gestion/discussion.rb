module EthilVan

   module Url::Gestion

      module DiscussionGroup

         include Url::Shared::DiscussionGroup

         extend self

         def root
            '/gestion/discussion'
         end
      end

      module Discussion

         include Url::Shared::Discussion

         extend self

         def root
            '/gestion/discussion'
         end
      end

      module Message

         include Url::Shared::Message

         extend self

         def root
            '/gestion/message'
         end
      end
   end
end
