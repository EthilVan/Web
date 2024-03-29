class EthilVan::App < Sinatra::Base

   class << (Account::Guest = Object.new)

      def logged_in?
         false
      end

      def role
         EthilVan::Role::GUEST
      end

      def role_id
         role.id
      end
   end

   helpers do

      def authenticate(pseudo, token)
         return Account::Guest if pseudo.nil?
         return Account::Guest if token.nil?
         account = Account.authenticate_by_token(pseudo, token)
         return Account::Guest if account.nil?
         job = EthilVan::Jobs::UpdateLastVisit.new(account, Time.now)
         EthilVan::Jobs.push(job)
         return account
      end
   end

   get '/login/?' do
      login = Login.new
      view Views::Public::Login.new login
      mustache 'public/login'
   end

   post '/login/?' do
      login = Login.new params[:login]
      if login.valid?
         account = login.account
         if login.remember
            token = account.generate_remembered_auth_token
         else
            token = account.generate_auth_token
         end
         login(account.name, token, login.remember)
         redirect_after_login
         redirect '/membre'
      end
      view Views::Public::Login.new login
      mustache 'public/login'
   end

   get '/membre/logout/?' do
      current_account.delete_auth_tokens
      logout
      redirect '/'
   end

end
