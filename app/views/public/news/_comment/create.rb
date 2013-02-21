module EthilVan::App::Views

   module Public::News::Comment

      class Create < Page

         def initialize(comment, url)
            @form = Form.new(comment, url)
         end

         def form
            @form
         end
      end
   end
end
