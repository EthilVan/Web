module EthilVan

   module Url::Member

      module Message

         extend self

         BASE = '/membre/message'

         def base(message)
            "#{BASE}/#{message.id}"
         end

         def show(discussion, page = nil, message = nil)
            base(discussion)
         end

         def discussion(message)
            Discussion.show(message.discussion, message.page, message)
         end

         def edit(message)
            base(message) + '/editer'
         end

         def delete(message)
            base(message) + '/supprimer'
         end
      end
   end
end
