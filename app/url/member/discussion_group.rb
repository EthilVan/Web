module EthilVan

   module Url::Member

      module DiscussionGroup

         extend self

         BASE = '/membre/discussion'

         def list
            BASE
         end

         def base(discussion_group)
            "#{BASE}/#{discussion_group.url}"
         end

         def all_read
            BASE + "/!toutes_lues"
         end

         def create
            BASE + "/!creer_espace"
         end

         def show(discussion_group, page = nil, message = nil)
            base(discussion_group)
         end

         def edit(discussion_group)
            base(discussion_group) + '/editer'
         end

         def delete(discussion_group)
            base(discussion_group) + '/supprimer'
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
   end
end
