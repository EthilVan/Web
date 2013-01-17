module EthilVan::App::Views

   module Member::Discussion

      class EditableMessage < Message

         def initialize(message, index, stats_max = nil)
            super(message, index, stats_max)
         end

         def can_edit
            true
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
