# encoding: utf-8

module EthilVan::App::Views

   module Member::Discussion

      class Message < Partial

         def initialize(message, index)
            @message = message
            @index = index
            @author = message.account
         end

         def anchor
            "msg#{@message.id}"
         end

         def can_edit
            false
         end

         def author_name
            @author.name
         end

         def author_avatar
            @author.profil.avatar_url
         end

         def author_profil
            "/membre/@#{@author.name}"
         end

         def author_signature
            signature = @author.profil.signature
            signature.nil? ? nil : render_markdown(signature)
         end

         def online
            return 'offline'
            @author.online? ? 'online' : 'offline'
         end

         def presence
            @presence ||= @author.minecraft_stats.version.to_f /
                  MinecraftStats.maximum('version')
         end

         def gauge_top
            129 - presence * 120
         end

         def gauge_height
            120 * presence
         end

         def even_class
            (@index % 2 == 0) ? 'odd' : 'even'
         end

         def contents
            @message.parsed_contents
         end

         def dates?
            !@message.new_record?
         end

         def created
            @message.created_at.strftime('%d/%m/%Y à  %H:%M')
         end

         def updated
            @message.updated_at.strftime('%d/%m/%Y à  %H:%M')
         end
      end
    end
end
