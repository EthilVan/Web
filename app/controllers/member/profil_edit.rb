class EthilVan::App

   helpers do

      def profil_edit_account(name)
         account = profil_account(name)
         not_authorized unless current_account.id == account.id or
               current_account.role.inherit? EthilVan::Role::MODO
         account
      end
   end

   get %r{/membre/@(#{Account::NAME})/editer$} do |name|
      redirect "/membre/@#{name}/editer/generale"
   end

   get %r{/membre/@(#{Account::NAME})/editer/generale$} do |name|
      account = profil_edit_account name
      view Views::Member::Profil::Edit::Tabs.new account
      mustache 'membre/profil/edit/tabs'
   end

   post %r{/membre/@(#{Account::NAME})/editer/generale$} do |name|
      account = profil_edit_account name

      if account.profil.update_attributes params[:profil]
         view Views::Member::Profil::Edit::Tabs.new account, {
            generale_ok: true
         }
         mustache 'membre/profil/edit/tabs'
      else
         view Views::Member::Profil::Edit::Tabs.new account
         mustache 'membre/profil/edit/tabs'
      end
   end

   get %r{/membre/@(#{Account::NAME})/editer/compte$} do |name|
      account = profil_edit_account name
      view Views::Member::Profil::Edit::Tabs.new account
      mustache 'membre/profil/edit/tabs'
   end

   post %r{/membre/@(#{Account::NAME})/editer/compte$} do |name|
      account = profil_edit_account name

      if not account.check_password?(params[:current_password])
         view Views::Member::Profil::Edit::Tabs.new account, {
            invalid_current_password: true
         }
         mustache 'membre/profil/edit/tabs'
      elsif account.update_attributes params[:account]
         account.clear_new_password
         view Views::Member::Profil::Edit::Tabs.new account, {
            account_ok: true
         }
         mustache 'membre/profil/edit/tabs'
      else
         view Views::Member::Profil::Edit::Tabs.new account
         mustache 'membre/profil/edit/tabs'
      end
   end
end
