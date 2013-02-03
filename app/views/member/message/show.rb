module EthilVan::App::Views

   module Member::Message

      class Show < Partial

         def initialize(message, index, stats_max = nil)
            @message = message
            @index = index
            @stats_max = stats_max
         end

         def discussion_name
            @message.discussion.name
         end

         def cadre
            Cadre.new(@message.account, @stats_max)
         end

         def anchor
            "msg#{@message.id}"
         end

         def first?
            @message.first_message?
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
