module EthilVan::App::Views

   module Member::Discussion

      class Edit < Page

         def initialize(discussion_urls, discussion)
            @form = Partials::Discussion::EditForm.new(discussion)
         end

         def form
            @form
         end
      end
   end
end
