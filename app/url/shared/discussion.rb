module EthilVan

   module Url::Shared

      module Discussion

         def base(discussion)
            "#{root}/#{discussion.id}"
         end

         def show(discussion, page = nil, message = nil)
            url = base(discussion)
            url << "?page=#{page}" if page
            url << "#msg#{message.id}" if message
            url
         end

         def respond(discussion, last_message)
            url = base(discussion) + '/repondre'
            url << "/#{last_message.id}" unless last_message.nil?
            url
         end

         def edit(discussion)
            base(discussion) + '/editer'
         end

         def delete(discussion)
            base(discussion) + '/supprimer'
         end
      end
   end
end
