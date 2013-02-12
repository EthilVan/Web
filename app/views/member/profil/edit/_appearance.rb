module EthilVan::App::Views

   module Member::Profil::Edit

      class Appearance < Partial

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

         def initialize(account, params)
            @form = Form.new(account.profil,
                  urls.profil_edit('apparence', account))
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
