module EthilVan::App::Views

   module Member::Discussion

      class Edit < Page

         def initialize(discussion)
            @form = Partials::Discussion::EditForm.new(discussion)
         end

         def form
            @form
         end
      end
   end
end
