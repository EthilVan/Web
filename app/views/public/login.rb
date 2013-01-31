module EthilVan::App::Views

   module Public

      module Authentication

         class Login < Page

            class Form < EthilVan::Mustache::Form

               def initialize(name, password, remember)
                  super()
                  @name = name
                  @password = password
                  @remember = remember
               end

               def name
                  text :name, @name, placeholder: 'Pseudo'
               end

               def password
                  text :password, @password, {
                        placeholder: 'Mot de Passe',
                        type: 'password'
                  }
               end

               def remember
                  checkbox :remember_me, @remember
               end
            end

            def initialize(name = nil, password = nil, remember = false,
                  invalid = false, banned = false)
               @form = Form.new(name, password, remember)
               @invalid = invalid
               @banned = banned
            end

            def form
               @form
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
