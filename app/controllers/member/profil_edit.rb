class EthilVan::App

   helpers do

      def profil_edit_account(name)
         account = profil_account(name)
         unless current_account.role.inherit? EthilVan::Role::MODO or
               current_account.id == account.id
            not_authorized
         end

         account
      end
   end

   get %r{/membre/@(#{Account::NAME})/editer$} do |name|
      redirect urls.profil_edit('generale', current_account)
   end

   get %r{/membre/@(#{Account::NAME})/editer/generale$} do |name|
      account = profil_edit_account name
      view Views::Member::Profil::Edit::Tabs.new account
      mustache 'membre/profil/edit/tabs'
   end

   post %r{/membre/@(#{Account::NAME})/editer/generale$} do |name|
      account = profil_edit_account name

      view Views::Member::Profil::Edit::Tabs.new account
      mustache 'membre/profil/edit/tabs'
   end

   get %r{/membre/@(#{Account::NAME})/editer/compte$} do |name|
      account = profil_edit_account name
      view Views::Member::Profil::Edit::Tabs.new account
      mustache 'membre/profil/edit/tabs'
   end

   post %r{/membre/@(#{Account::NAME})/editer/compte$} do |name|
      account = profil_edit_account name

      view Views::Member::Profil::Edit::Tabs.new account
      mustache 'membre/profil/edit/tabs'
   end
end
