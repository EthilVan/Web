class EthilVan::App < Sinatra::Base

   get '/login' do
      view Views::Public::Authentication::Login.new
      mustache 'public/authentication/login'
   end

   post '/login' do
      name, password = params[:name], params[:password]
      remember = !params['remember_me'].nil? and params['remember_me'] == '1'
      account = Account.authenticate(name, password)
      if account.nil?
         view Views::Public::Authentication::Login.new(
               name, password, remember, true)
         mustache 'public/authentication/login'
      elsif account.banned
         view Views::Public::Authentication::Login.new(
               name, password, remember, false, true)
         mustache 'public/authentication/login'
      else
         login(account, remember)
         redirect_after_login
         redirect '/membre'
      end
   end

   get '/membre/logout' do
      logout
      redirect '/'
   end
end
