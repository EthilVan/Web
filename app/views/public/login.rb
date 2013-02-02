module EthilVan::App::Views

   module Public

      module Authentication

         class Login < Page

            class Form < EthilVan::Mustache::Form

               def initialize(login)
                  super(login)
               end

               def name
                  text :name
               end

               def password
                  password_f :password
               end

               def remember
                  checkbox :remember
               end
            end

            def initialize(login)
               @form = Form.new(login)
               @login = login
            end

            def form
               @form
            end

            def invalid?
               @login.account.nil?
            end

            def banned?
               @login.banned
            end
         end
      end
   end
end
