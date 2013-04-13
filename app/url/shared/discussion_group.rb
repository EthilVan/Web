module EthilVan

   module Url::Shared

      module DiscussionGroup

         def list
            root
         end

         def base(discussion_group)
            "#{root}/#{discussion_group.url}"
         end

         def all_read
            root + "/!toutes_lues"
         end

         def create
            root + "/!creer_espace"
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
      end
   end
end
