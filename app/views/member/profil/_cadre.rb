module EthilVan::App::Views

    module Member::Profil

        class Cadre < Partial

            def initialize(account, profil = account.profil,
                  minecraft_stats = account.minecraft_stats)
               @account = account
               @profil = profil
               @minecraft_stats = minecraft_stats
            end

            def account_name
               @account.name
            end

            def presence
               @presence ||= (@minecraft_stats.version.to_f /
                     MinecraftStats.maximum('version'))
            end

            def cadre_url
               @profil.cadre_url
            end

            def gauge_top
               129 - presence * 120
            end

            def gauge_height
               120 * presence
            end

            def avatar
               @profil.avatar_url
            end

            def online_class
               @account.online? ? 'online' : 'offline'
            end

            def skin_url
               urls.skin_preview @account, 5
            end

            def deaths
               @minecraft_stats.deaths
            end

            def max_level
               @minecraft_stats.max_level
            end
        end
    end
end
