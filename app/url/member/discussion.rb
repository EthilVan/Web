module EthilVan

   module Url::Member

      module DiscussionGroup

         include Url::Shared::DiscussionGroup

         extend self

         def root
            '/membre/discussion'
         end

         def follow_all(discussion_group)
            base(discussion_group) + "/toutsuivre"
         end

         def unfollow_all(discussion_group)
            base(discussion_group) + "/neplusriensuivre"
         end

         def follow(discussion_group)
            base(discussion_group) + '/suivre'
         end

         def unfollow(discussion_group)
            base(discussion_group) + '/neplussuivre'
         end
      end

      module Discussion

         include Url::Shared::Discussion

         extend self

         def root
            '/membre/discussion'
         end

         def follow(discussion)
            base(discussion) + '/suivre'
         end

         def unfollow(discussion)
            base(discussion) + '/neplussuivre'
         end
      end

      module Message

         include Url::Shared::Message

         extend self

         def root
            '/membre/message'
         end
      end
   end
end
