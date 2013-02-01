module EthilVan::App::Views

   module Member::DiscussionGroup

      class Edit < Page

         def initialize(group)
            @form = Form.new(group)
         end

         def form
            @form
         end
      end
   end
end
