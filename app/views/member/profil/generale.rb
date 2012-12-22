# encoding: utf-8

module EthilVan::App::Views

   module Member::Profil

      class Generale < Partial

         def initialize(account)
            @account = account
            @profil = account.profil
            @minecraft_stats = account.minecraft_stats
         end

         def cadre
            Cadre.new(@account, @profil, @minecraft_stats)
         end

         def account_name
            @account.name
         end

         def show_email?
            role = @app.current_account.role
            role.inherit? EthilVan::Role::MODO
         end

         def email
            @account.email
         end

         def role
            @account.role.name
         end

         def since
            @profil.created_at.interval.format_since.capitalize
         end

         def last_visit
            return "Jamais" if @account.last_visit.nil?
            return "Actuellement Connecté" if @account.online?
            "Il y a " + @account.last_visit.interval.format_ago
         end

         def last_minecraft_visit
            return "Jamais" if @minecraft_stats.last_visit.nil?
            "Il y a " + @minecraft_stats.last_visit.interval.format_ago
         end

         def minecraft_since
            @profil.minecraft_since
         end

         presence_predicate :skill
         def skill
            @profil.skill
         end

         presence_predicate :desc_rp
         def desc_rp
            @profil.desc_rp
         end

         def age?
            @profil.birthdate.present?
         end

         def age
            time = Time.now - @profil.birthdate.to_time
            Time.at(time).year - 1970
         end

         presence_predicate :sexe
         def sexe
            #::Postulation::Sexe.rassoc(@profil.sexe)[0]
            @profil.sexe
         end

         presence_predicate :localisation
         def localisation
            @profil.localisation
         end

         presence_predicate :website
         def website
            @profil.website
         end

         presence_predicate :twitter
         def twitter
            @profil.twitter
         end

         presence_predicate :youtube
         def youtube
            @profil.youtube
         end

         presence_predicate :steam_id
         def steam_id
            @profil.steam_id
         end

         presence_predicate :description
         def description
            @profil.description
         end
      end
   end
end
