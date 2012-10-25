# encoding: utf-8

class EthilVan::App < Sinatra::Base

   get '/membre/login' do
      logout if logged_in?
      view Views::Public::Authentication::Login.new
      mustache "public/authentication/login"
   end

   post '/membre/login' do
      account = Account.authenticate(params[:name], params[:password])
      if account.nil?
         view Views::Public::Authentication::Login.new(
               "Mot de passe ou pseudo invalide.")
         mustache "public/authentication/login"
      elsif account.banned
         view Views::Public::Authentication::Login.new(
               "Vous êtes banni de ce site.")
         mustache "public/authentication/login"
      else
         login(account.auth_token, !params["remember_me"].nil?)
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
