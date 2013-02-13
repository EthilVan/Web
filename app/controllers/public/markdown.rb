require 'sinatra/json'

class EthilVan::App < Sinatra::Base

   helpers Sinatra::JSON

   logged_only %r{/markdown(?:$|/)}

   post '/markdown' do
      markdown params['content']
   end

   get '/markdown/membres.json' do
      json Account.where("role_id != 'ancien'").pluck(:name)
   end
end
