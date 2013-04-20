module EthilVan::App::Views

    module Partials::Account

        class Cadre < Partial

            def initialize(account)
               @account = account
            end

            def name
               @account.name
            end

            def avatar
               @account.profil.avatar_url
            end

            def profil_url
               urls::Member::Profil.show(@account)
            end

            def activities_url
               urls::Member::Profil.activities(@account)
            end

            def background_url
               @account.profil.cadre_url
            end

            def presence
               @presence ||= (@account.activity_stat.value * 120).to_int
            end

            def gauge_top
               129 - presence
            end

            def gauge_height
               presence
            end

            def online_class
               @account.online? ? 'online' : 'offline'
            end

            def skin_url
               urls::Member::Skin.preview(@account, 5)
            end

            def deaths
               @account.minecraft_stats.deaths
            end

            def max_level
               @account.minecraft_stats.max_level
            end
        end
    end
end
