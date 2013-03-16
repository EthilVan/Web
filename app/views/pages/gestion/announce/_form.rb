module EthilVan::App::Views

   module Gestion::Announce

      class Form < EthilVan::Mustache::Form

         def initialize(announce, action = '')
            super(announce, action: action)
         end

         def content
            markdown :content, validations: {
               required: true
            }
         end

         def inline?
            @app.xhr?
         end
      end
   end
end
