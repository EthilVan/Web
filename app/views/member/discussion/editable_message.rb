module EthilVan::App::Views

   module Member::Discussion

      class EditableMessage < Message

         def initialize(message, index, stats_max, base_url)
            super(message, index, stats_max)
            @base_url = base_url
         end

         def can_edit
            true
         end

         def edit_url
            "#{@base_url}/editer?msg=#{@message.id}"
         end

         def delete_url
            "#{@base_url}/supprimer?msg=#{@message.id}"
         end
      end
   end
end
