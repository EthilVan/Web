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
      redirect "/membre/@#{name}/editer/general"
   end

   get %r{/membre/@(#{Account::NAME})/editer/(?:general|apparence|compte)$} do |name|
      account = profil_edit_account name
      view Views::Member::Profil::Edit::Tabs.new account
      mustache 'membre/profil/edit/tabs'
   end

   post %r{/membre/@(#{Account::NAME})/editer/general$} do |name|
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

   post %r{/membre/@(#{Account::NAME})/editer/apparence$} do |name|
      account = profil_edit_account name

      if account.profil.update_attributes params[:profil]
         view Views::Member::Profil::Edit::Tabs.new account, {
            appearance_ok: true
         }
         mustache 'membre/profil/edit/tabs'
      else
         view Views::Member::Profil::Edit::Tabs.new account
         mustache 'membre/profil/edit/tabs'
      end
   end

   post %r{/membre/@(#{Account::NAME})/editer/compte$} do |name|
      account = profil_edit_account name

      own_account = current? account
      role = has_role?(account.role)
      super_role = has_super_role?(account.role)

      account_params = params[:account]

      account.vote_needed = account_params.delete('vote_needed') if role
      account.banned = account_params.delete('banned') if super_role
      account.attributes = account_params if own_account or super_role

      if not current_account.check_password?(params[:current_password])
         view Views::Member::Profil::Edit::Tabs.new account, {
            invalid_current_password: true
         }
         mustache 'membre/profil/edit/tabs'
      elsif account.save
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
