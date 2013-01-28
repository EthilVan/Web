module EthilVan::App::Views

   module Member::Discussion

      class Message < Partial

         def initialize(message, index)
            @message = message
            @index = index
         end

         def anchor
            "msg#{@message.id}"
         end

         def view_url
            "/membre/message/#{@message.id}"
         end

         def even_class
            (@index % 2 == 0) ? ' odd' : ' even'
         end

         def contents
            @message.parsed_contents
         end

         def dates?
            !@message.new_record?
         end

         def created
            I18n.l @message.created_at
         end

         def updated
            I18n.l @message.updated_at
         end
      end
    end
end
