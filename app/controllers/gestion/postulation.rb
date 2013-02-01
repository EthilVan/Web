class EthilVan::App < Sinatra::Base

   get '/gestion/postulation' do
      postulations = Postulation.by_date
      view Views::Gestion::Postulation::List.new postulations
      mustache 'gestion/postulation/list'
   end

   get '/gestion/postulation/:name' do |name|
      postulation = Postulation.where(name: name).first
      raise Sinatra::NotFound if postulation.nil?
      view Views::Gestion::Postulation::Show.new postulation
      mustache 'gestion/postulation/show'
   end
end
