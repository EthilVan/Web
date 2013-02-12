require 'sinatra/json'

class EthilVan::App < Sinatra::Base

   helpers Sinatra::JSON

   post '/markdown' do
      not_authorized if guest?
      markdown params['content']
   end

   get '/markdown/membres.json' do
      not_authorized if guest?
      json Account.where("role_id != 'ancien'").pluck(:name)
   end
end
