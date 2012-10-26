class EthilVan::App < Sinatra::Base

   get '/login' do
      logout if logged_in?
      view Views::Public::Authentication::Login.new
      mustache "authentication/login"
   end

   post '/login' do
      name, password = params[:name], params[:password]
      remember = !params["remember_me"].nil? and params["remember_me"] == "1"
      account = Account.authenticate(name, password)
      if account.nil?
         view Views::Public::Authentication::Login.new(
               name, password, remember, true)
         mustache "authentication/login"
      elsif account.banned
         view Views::Public::Authentication::Login.new(
               name, password, remember, false, true)
         mustache "authentication/login"
      else
         login(account.auth_token, remember)
         redirect_after_login
         redirect "/"
      end
   end

   get '/membre/logout' do
      current_account.generate_auth_token
      current_account.save
      logout
      redirect '/'
   end
end
