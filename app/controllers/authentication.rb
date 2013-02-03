class EthilVan::App < Sinatra::Base

   get '/login' do
      login = Login.new
      view Views::Public::Login.new login
      mustache 'public/login'
   end

   post '/login' do
      login = Login.new(params[:login])
      if login.valid?
         login(login.account, login.remember)
         redirect_after_login
         redirect '/membre'
      end
      view Views::Public::Login.new login
      mustache 'public/login'
   end

   get '/membre/logout' do
      logout
      redirect '/'
   end
end
