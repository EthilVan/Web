class EthilVan::App < Sinatra::Base

   helpers do

      def account_for(name)
         account = Account.with_everything.where(name: name).first
         raise Sinatra::NotFound if account.nil?
         account
      end
   end

   get '/membre/profil' do
      redirect urls.profil('generale', current_account)
   end

   get %r{/membre/@(#{Account::NAME})$} do |name|
      redirect "/membre/@#{name}/generale"
   end

   get %r{/membre/@(#{Account::NAME})/generale$} do |name|
      account = account_for name
      view Views::Member::Profil::Layout.new(account)
      mustache 'membre/profil/layout'
   end

   get %r{/membre/@(#{Account::NAME})/postulation$} do |name|
      account = account_for name
      view Views::Member::Profil::Layout.new(account)
      mustache 'membre/profil/layout'
   end

   get %r{/membre/@(#{Account::NAME})/tags$} do |name|
      account = account_for name
      view Views::Member::Profil::Layout.new(account)
      mustache 'membre/profil/layout'
   end
end
