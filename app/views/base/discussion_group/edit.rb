module EthilVan::App::Views

   module Base::DiscussionGroup

      class Edit < Page

         def initialize(discussion_urls, group)
            @form = Partials::DiscussionGroup::Form.new(group)
         end

         def form
            @form
         end
      end
   end
end
