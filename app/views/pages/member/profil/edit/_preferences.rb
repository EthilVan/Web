module EthilVan::App::Views

   module Member::Profil::Edit

      class Preferences < PageTab

         class Form < EthilVan::Mustache::Form

            def initialize(profil, action)
               super(profil, action: action)
            end

            def show_email
               boolean :show_email
            end

            def news_categories
               categories = NewsCategories.names
                     .each_with_object({}) do |category, h|
                  h[category] = EthilVan::Data::News::Categories[category.to_s]
               end
               multichoice :categories, among: categories
            end
         end

         def initialize(page, account, params)
            super(page, 'preferences')
            @form = Form.new(account.profil,
                  urls::Member::Profil::Edit.preferences(account))
            @params = params
         end

         def ok?
            @params[:preferences_ok]
         end

         def form
            @form
         end
      end
   end
end
