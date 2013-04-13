module EthilVan::App::Views

   module Gestion::DiscussionGroup

      class Create < Page

         def initialize(discussion_urls, group)
            @form = Partials::DiscussionGroup::Form.new(group)
         end

         def form
            @form
         end
      end
   end
end
