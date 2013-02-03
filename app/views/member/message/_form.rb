module EthilVan::App::Views

   module Member::Message

      class Form < EthilVan::Mustache::Form

         def initialize(message, action)
            super(message, action: action)
         end

         def contents
            text :contents
         end
      end
   end
end
