require 'sinatra/json'

class EthilVan::App < Sinatra::Base

   helpers Sinatra::JSON

   get '/' do
      redirect '/presentation/generale'
   end

   post '/markdown' do
      markdown params['content']
   end

   get '/markdown/membres.json' do
      json Account.where("role_id != 'ancien'").pluck(:name)
   end
end
