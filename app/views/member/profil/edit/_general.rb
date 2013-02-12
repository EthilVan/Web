module EthilVan::App::Views

   module Member::Profil::Edit

      class General < Partial

         def initialize(account, params)
            @form = Form.new(account.profil,
                  urls.profil_edit('general', account))
            @params = params
         end

         def ok?
            @params[:generale_ok]
         end

         def form
            @form
         end
      end

      class General::Form < EthilVan::Mustache::Form

         def initialize(profil, action)
            super(profil, action: action)
         end

         def show_email
            checkbox :show_email
         end

         def birthdate
            text :birthdate_formatted
         end

         def sexe
            select :sexe, {
               among: Hash[*EthilVan::Data::Sexe.map(&:reverse).flatten]
            }
         end

         def localisation
            text :localisation
         end

         def minecraft_since
            text :minecraft_since
         end

         def skill
            text :skill
         end

         def desc_rp
            text :desc_rp
         end

         def website
            text :website
         end

         def twitter
            text :twitter
         end

         def youtube
            text :youtube
         end

         def steam_id
            text :steam_id
         end

         def description
            text :description
         end
      end
   end
end
