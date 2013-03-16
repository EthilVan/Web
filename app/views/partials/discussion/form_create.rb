module EthilVan::App::Views

   module Partials::Discussion

      class CreateForm < EthilVan::Mustache::Form

         class MessageFields < EthilVan::Mustache::Form::Association

            def contents
               text :contents
            end
         end

         def initialize(discussion)
            super(discussion)
         end

         def name
            text :name
         end

         def first_message
            association MessageFields, :first_message
         end

         def author_signature
            @model.first_message.account.profil.parsed_signature
         end
      end
   end
end
