module EthilVan::App::Views

   module Member::Message

      class Show < Partial

         def initialize(message, stats_max = nil)
            @message = message
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

         def author_signature
            @message.account.profil.parsed_signature
         end
      end
    end
end
