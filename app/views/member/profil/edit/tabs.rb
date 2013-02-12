# encoding: utf-8

module EthilVan::App::Views

   module Member::Profil::Edit

      class Tabs < Page

         TABS = [
            { id: 'general',     name: 'Général'   },
            { id: 'apparence',   name: 'Apparence' },
            { id: 'compte',      name: 'Compte'    },
         ]

         def initialize(account, params = {})
            @account = account
            @params = params
         end

         def meta_page_title
            "Edition | @#{@account.name} | Ethil Van"
         end

         def tabs?
            true
         end

         def tabs
            base_title = meta_page_title
            TABS.map do |tab_proto|
               tab = tab_proto.clone
               tab[:tab_title] = tab[:name] + ' | ' + base_title
               tab
            end
         end

         def tab_general
            General.new(@account, @params)
         end

         def tab_appearance
            Appearance.new(@account, @params)
         end

         def tab_account
            Account.new(@account, @params)
         end
      end
   end
end
