module EthilVan::App::Views

   module Member::Profil::Edit

      class Tabs < Page

         def initialize(account, params = {})
            @account = account
            @tab_general = General.new(self, account, params)
            @tab_appearance = Appearance.new(self, account, params)
            @tab_account = Account.new(self, account, params)
         end

         def _page_title
            @page_title ||= [
               current?(@account) ? 'Profil' : '@' + @account.name,
               'Edition'
            ]
         end

         def page_tabs
            @page_tabs ||= [
               @tab_general,
               @tab_appearance,
               @tab_account,
            ]
         end

         def tab_general
            @tab_general
         end

         def tab_appearance
            @tab_appearance
         end

         def tab_account
            @tab_account
         end
      end
   end
end
