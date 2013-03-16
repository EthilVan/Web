module EthilVan::App::Views

   module Public::News

      class Edit < Page

         def initialize(news)
            @form = Form.new(news)
         end

         def edit_form?
            true
         end

         def form
            @form
         end
      end
   end
end
