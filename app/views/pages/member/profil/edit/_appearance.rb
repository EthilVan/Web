module EthilVan::App::Views

   module Member::Profil::Edit

      class Appearance < PageTab

         class Form < EthilVan::Mustache::Form

            def initialize(profil, action)
               super(profil, action: action)
            end

            def avatar
               text :avatar, validations: {
                  type: "urlstrict"
               }
            end

            def cadre_url
               text :custom_cadre_url, validations: {
                  type: "urlstrict"
               }
            end

            def signature
               markdown :signature
            end
         end

         def initialize(page, account, params)
            super(page, 'apparence')
            @form = Form.new(account.profil,
                  urls::Member::Profil::Edit.appearance(account))
            @params = params
         end

         def ok?
            @params[:appearance_ok]
         end

         def form
            @form
         end
      end
   end
end
