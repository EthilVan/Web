class EthilVan::App < Sinatra::Base

   helpers do

      def profil_account(name)
         resource Account.with_everything.where(name: name).first
      end

      def profil_activities(account)
         resources Activity.list(account, params[:activities_page])
      end

      def profil_messages(account)
         resources Message.for_account(account).page(params[:msgpage]).per(10)
      end

      def profil_tags(account)
         resources account.profil_tags.page(params[:tagspage]).per(25)
      end

      def profil_new_tag(account, params = {})
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

   xhr_get %r{/membre/@(#{Account::NAME})/activites$} do |name|
      account    = profil_account    name
      activities = profil_activities account

      view Views::Member::Profil::Messages.new(nil, account, messages)
      mustache 'membre/profil/_messages'
   end

   xhr_get %r{/membre/@(#{Account::NAME})/messages$} do |name|
      account  = profil_account  name
      messages = profil_messages account

      view Views::Member::Profil::Messages.new(nil, account, messages)
      mustache 'membre/profil/_messages'
   end

   xhr_get %r{/membre/@(#{Account::NAME})/tags$} do |name|
      account  = profil_account  name
      tags     = profil_tags     account

      view Views::Member::Profil::Tags.new(nil, account, nil, tags)
      mustache 'membre/profil/_tags'
   end

   tabs = %w{general postulation activites tags messages}
   get %r{/membre/@(#{Account::NAME})/(?:#{tabs *  '|'})$} do |name|
      account    = profil_account    name
      activities = profil_activities account
      new_tag    = profil_new_tag    account
      tags       = profil_tags       account
      messages   = profil_messages   account

      view Views::Member::Profil::Tabs.new(account, activities,
         new_tag, tags, messages)
      mustache 'membre/profil/tabs'
   end

   post %r{/membre/@(#{Account::NAME})/tags$} do |name|
      account = profil_account name
      new_tag = profil_new_tag account, params[:profil_tag]

      if new_tag.save
         redirect urls.profil('tags', account)
      else
         tags     = profil_tags     account
         messages = profil_messages account
         view Views::Member::Profil::Tabs.new(account, new_tag, tags, messages)
         mustache 'membre/profil/tabs'
      end
   end
end
