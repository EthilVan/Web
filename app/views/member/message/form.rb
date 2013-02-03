module EthilVan::App::Views

   module Member::Message

      class Form < EthilVan::Mustache::Form

         def initialize(message)
            super(message)
         end

         def contents
            text :contents
         end
      end
   end
end
