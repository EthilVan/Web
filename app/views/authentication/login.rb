module EthilVan::App::Views

   module Public

      module Authentication

         class Login < Page

            include EthilVan::Mustache::Form

            def initialize(name = nil, password = nil, remember = false,
                  invalid = false, banned = false)
               @name = name
               @password = password
               @remember = remember
               @invalid = invalid
               @banned = banned
            end

            def name
               field @name
            end

            def password
               field @password
            end

            def remember
               checkbox @remember
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
