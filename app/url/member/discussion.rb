module EthilVan

   module Url::Membre

      module Discussion

         extend self

         BASE = '/membre/discussion'

         def base(discussion)
            "#{BASE}/#{discussion.id}"
         end

         def show(discussion, page = nil, message = nil)
            url = base(discussion)
            url << "?page=#{page}" if page
            url << "#msg#{message.id}" if message
            url
         end

         def edit(discussion)
            base(discussion) + '/editer'
         end

         def delete(discussion)
            base(discussion) + '/supprimer'
         end

         def follow(discussion)
            base(discussion) + '/suivre'
         end

         def unfollow(discussion)
            base(discussion) + '/neplussuivre'
         end
      end
   end
end
