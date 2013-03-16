module EthilVan::App::Views

   module Partials::Message

      class Form < EthilVan::Mustache::Form

         def initialize(message, inline = false, action = '')
            super(message, action: action)
            @inline = inline
         end

         def inline?
            @inline
         end

         def contents
            markdown :contents
         end

         def author_signature
            @model.account.profil.parsed_signature
         end
      end
   end
end
