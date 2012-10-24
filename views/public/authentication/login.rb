module EthilVan::App::Views

   module Public

      module Authentication

         class Login < EthilVan::Mustache::Page

            def initialize(error = nil)
               @error = error
            end

            def error?
               @error != nil
            end

            def error
               @error
            end
         end
      end
   end
end
