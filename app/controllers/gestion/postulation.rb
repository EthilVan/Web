class EthilVan::App < Sinatra::Base

   get '/gestion/postulation' do
      postulations = Postulation.by_date
      view Views::Gestion::Postulation::List.new postulations
      mustache 'gestion/postulation/list'
   end

   get '/gestion/postulation/:name' do |name|
      postulation = Postulation.where(name: name).first
      raise Sinatra::NotFound if postulation.nil?

      vote = nil
      if postulation.pending? and
            not PostulationVote.for?(current_account, postulation)
         vote = PostulationVote.new
         vote.account = current_account
         vote.postulation = postulation
      end

      view Views::Gestion::Postulation::Show.new postulation, vote
      mustache 'gestion/postulation/show'
   end

   post '/gestion/postulation/:name' do |name|
      postulation = Postulation.where(name: name).first
      if postulation.nil? or !postulation.pending? or
            PostulationVote.for?(current_account, postulation)
         raise Sinatra::NotFound
      end

      vote = PostulationVote.new(params[:postulation_vote])
      vote.account = current_account
      vote.postulation = postulation

      if vote.save
         view Views::Gestion::Postulation::Show.new postulation, nil
         mustache 'gestion/postulation/show'
      else
         view Views::Gestion::Postulation::Show.new postulation, vote
         mustache 'gestion/postulation/show'
      end
   end
end
