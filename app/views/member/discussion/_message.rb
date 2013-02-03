module EthilVan::App::Views

   module Member::Discussion

      class Message < Member::Message::Show

         def initialize(message, index, stats_max = nil)
            super(message, index)
            @author = message.account
            @stats_max = stats_max
         end

         def stats_max
            @stats_max ||= MinecraftStats.maximum('version')
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
            urls.profil @author
         end

         def author_signature
            @author.profil.parsed_signature
         end

         def online
            @author.online? ? 'online' : 'offline'
         end

         def presence
            @presence ||= @author.minecraft_stats.version.to_f / stats_max
         end

         def gauge_top
            129 - presence * 120
         end

         def gauge_height
            120 * presence
         end

      end
   end
end
