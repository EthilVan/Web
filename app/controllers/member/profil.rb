class EthilVan::App < Sinatra::Base

   get '/membre/profil' do
      redirect urls.profil('generale', current_account)
   end

   get %r{/membre/@(#{Account::NAME})$} do |name|
      redirect "/membre/@#{name}/generale"
   end

   get %r{/membre/@(#{Account::NAME})/messages$} do
      pass unless request.xhr?
      layout false
      account = Account.with_everything.where(name: name).first
      raise Sinatra::NotFound if account.nil?
      messages = Message.for_account(account).page(params[:page]).per(10)

      view Views::Member::Profil::Messages.new(account, messages)
      mustache 'membre/profil/_messages'
   end

   tabs = [:generale, :postulation, :tags, :messages]
   get %r{/membre/@(#{Account::NAME})/(?:#{tabs *  '|'})$} do |name|
      account = Account.with_everything.where(name: name).first
      raise Sinatra::NotFound if account.nil?
      messages = Message.for_account(account).page(params[:page]).per(10)

      view Views::Member::Profil::Layout.new(account, messages)
      mustache 'membre/profil/layout'
   end
end
