module EthilVan::App::Views

   module Base::Discussion

      class Create < Page

         def initialize(discussion_urls, discussion)
            @form = Partials::Discussion::CreateForm.new(discussion)
         end

         def form
            @form
         end

         def cadre
            @cadre = Partials::Account::Cadre.new(@app.current_account)
         end
      end
   end
end
