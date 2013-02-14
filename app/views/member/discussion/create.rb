module EthilVan::App::Views

   module Member::Discussion

      class Create < Page

         class Form < EthilVan::Mustache::Form

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

         def initialize(discussion)
            @form = Form.new(discussion)
         end

         def form
            @form
         end

         def cadre
            @cadre = Member::Message::Cadre.new(@app.current_account)
         end
      end
   end
end
