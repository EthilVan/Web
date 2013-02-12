class EthilVan::App < Sinatra::Base

   helpers do

      def profil_account(name)
         resource Account.with_everything.where(name: name).first
      end

      def profil_messages(account)
         resources Message.for_account(account).page(params[:msgpage]).per(10)
      end

      def profil_tag(account, params = {})
         return nil if current_account.id == account.id
         tag = ProfilTag.new params
         tag.tagged = account
         tag.tagger = current_account
         tag
      end
   end

   get '/membre/profil' do
      redirect urls.profil('general', current_account)
   end

   get %r{/membre/@(#{Account::NAME})$} do |name|
      redirect "/membre/@#{name}/general"
   end

   xhr_get %r{/membre/@(#{Account::NAME})/messages$} do |name|
      account  = profil_account  name
      messages = profil_messages account

      view Views::Member::Profil::Messages.new(account, messages)
      mustache 'membre/profil/_messages'
   end

   tabs = [:general, :postulation, :tags, :messages]
   get %r{/membre/@(#{Account::NAME})/(?:#{tabs *  '|'})$} do |name|
      account  = profil_account  name
      tag      = profil_tag      account
      messages = profil_messages account

      view Views::Member::Profil::Tabs.new(account, tag, messages)
      mustache 'membre/profil/tabs'
   end

   post %r{/membre/@(#{Account::NAME})/tags$} do |name|
      account = profil_account name
      tag     = profil_tag     account, params[:profil_tag]

      if tag.save
         redirect urls.profil('tags', account)
      else
         messages = profil_messages account
         view Views::Member::Profil::Tabs.new(account, tag, messages)
         mustache 'membre/profil/tabs'
      end
   end
end
