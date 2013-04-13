EthilVan.development? do

   class EthilVan::App < Sinatra::Base

      get '/dev/login/:account/?' do |account_name|
         account = Account.where(name: account_name).first
         halt "Pas de membre avec le pseudo #{account_name}" if account.nil?
         token = account.generate_auth_token
         login(account.name, token, false)
         redirect '/'
      end

      logged_only %r{^/dev/role/}
      get '/dev/role/:new_role/?' do |new_role|
         current_account.update_attribute :role_id, new_role
         redirect '/'
      end
   end
end
