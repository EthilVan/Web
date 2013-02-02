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
               not @login.errors[:credentials].empty?
            end

            def banned?
               not @login.errors[:banned].empty?
            end
         end
      end
   end
end
