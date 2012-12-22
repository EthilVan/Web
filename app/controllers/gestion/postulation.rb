class EthilVan::App < Sinatra::Base

   get '/gestion' do
      redirect '/gestion/postulation'
   end

   # Legacy
   get %r{/moderation(?:$|/)} do
      redirect request.path.gsub(%r{^/moderation}, '/gestion')
   end

   get '/gestion/postulation' do
      postulations = Postulation.by_date
      view Views::Gestion::Postulation::List.new(postulations)
      mustache 'gestion/postulation/list'
   end
end
