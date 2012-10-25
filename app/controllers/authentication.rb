class EthilVan::App < Sinatra::Base

   get '/login' do
      logout if logged_in?
      view Views::Public::Authentication::Login.new
      mustache "authentication/login"
   end

   post '/login' do
      account = Account.authenticate(params[:name], params[:password])
      if account.nil?
         view Views::Public::Authentication::Login.new(true)
         mustache "authentication/login"
      elsif account.banned
         view Views::Public::Authentication::Login.new(false, true)
         mustache "authentication/login"
      else
         login(account.auth_token, !params["remember_me"].nil?)
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
