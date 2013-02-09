module EthilVan::App::Views

   module Member::Discussion

      class Message < Member::Message::Show

         def initialize(message, can_edit, stats_max = nil)
            super(message, stats_max)
            @can_edit = can_edit
         end

         def can_edit
            @can_edit
         end

         def edit_url
            "/membre/message/#{@message.id}/editer"
         end

         def delete_url
            "/membre/message/#{@message.id}/supprimer"
         end
      end
   end
end
