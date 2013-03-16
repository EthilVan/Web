module EthilVan::App::Views

   module Member::Discussion

      class Create < Page

         def initialize(discussion)
            @form = Partials::Discussion::CreateForm.new(discussion)
         end

         def form
            @form
         end

         def cadre
            @cadre = Partials::Message::Cadre.new(@app.current_account)
         end
      end
   end
end
