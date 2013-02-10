class EthilVan::App < Sinatra::Base

   get '/gestion/postulation' do
      postulations = Postulation.by_date
      view Views::Gestion::Postulation::List.new postulations
      mustache 'gestion/postulation/list'
   end

   get '/gestion/postulation/:name' do |name|
      postulation = resource Postulation.where(name: name).first

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
      postulation = resource Postulation.where(name: name).first
      not found if !postulation.pending? or
            PostulationVote.for?(current_account, postulation)

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
