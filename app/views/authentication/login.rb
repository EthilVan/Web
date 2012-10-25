module EthilVan::App::Views

   module Public

      module Authentication

         class Login < EthilVan::Mustache::Page

            def initialize(invalid = false, banned = false)
               @invalid = invalid
               @banned = banned
            end

            def invalid?
               @invalid
            end

            def banned?
               @banned
            end
         end
      end
   end
end
