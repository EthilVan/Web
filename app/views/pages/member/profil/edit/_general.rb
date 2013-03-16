module EthilVan::App::Views

   module Member::Profil::Edit

      class General < PageTab

         def initialize(page, account, params)
            super(page, 'general')
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
            boolean :show_email
         end

         def birthdate
            text :birthdate_formatted, validations: {
               datefr: true
            }
         end

         def sexe
            choice :sexe, among: EthilVan::Data::Sexe
         end

         def localisation
            text :localisation
         end

         def minecraft_since
            text :minecraft_since, validations: {
               minlength: 20
            }
         end

         def skill
            text :skill
         end

         def desc_rp
            text :desc_rp
         end

         def website
            text :website, validations: {
               type: 'urlstrict'
            }
         end

         def twitter
            text :twitter, validations: {
               nameformat: true
            }
         end

         def youtube
            text :youtube, validations: {
               nameformat: true
            }
         end

         def steam_id
            text :steam_id, validations: {
               nameformat: true
            }
         end

         def description
            text :description
         end
      end
   end
end
