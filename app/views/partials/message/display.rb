module EthilVan::App::Views

   module Partials::Message

      class Display < Partial

         def initialize(message, can_edit, stats_max = nil)
            @message = message
            @stats_max = stats_max
            @can_edit = can_edit
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
            @message.first?
         end

         def view_url
            urls::Member::Message.show(@message)
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

         def can_edit?
            @can_edit
         end

         def edit_url
            urls::Member::Message.edit(@message)
         end

         def delete_url
            urls::Member::Message.delete(@message)
         end
      end
    end
end
