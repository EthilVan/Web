module EthilVan::App::Views

   module Public::Postulation

      class Formulaire < Page

         def initialize(postulation)
            @form = Form.new(postulation)
         end

         def form
            @form
         end
      end
   end
end
