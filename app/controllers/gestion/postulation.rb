class EthilVan::App < Sinatra::Base

   get '/gestion/postulation/?' do
      postulations = Postulation.by_date
      view Views::Gestion::Postulation::List.new postulations
      mustache 'gestion/postulation/list'
   end

   get '/gestion/postulation/:name/?' do |name|
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

   post '/gestion/postulation/:name/?' do |name|
      postulation = resource Postulation.where(name: name).first
      not_found if !postulation.pending? or
            PostulationVote.for?(current_account, postulation)

      vote = PostulationVote.new(params[:postulation_vote])
      vote.account = current_account
      vote.postulation = postulation

      if vote.save
         after_vote(postulation, vote)
         view Views::Gestion::Postulation::Show.new postulation, nil
         mustache 'gestion/postulation/show'
      else
         view Views::Gestion::Postulation::Show.new postulation, vote
         mustache 'gestion/postulation/show'
      end
   end

   helpers do

      def after_vote(postulation, vote)
         visitor = Visitor.where(name: postulation.minecraft_name)
         vote_mail = Views::Mails::Postulation.new(postulation, vote)

         if vote.agreement_needed?
            agreements = postulation.agreements_needed.size
            total = PostulationVote.total_needed
            if agreements >= total
               visitor.destroy_all
               postulation.update_attribute :status, 2
               Account.create_from_postulation(postulation)
               mail_view vote_mail
               mail 'postulation/validation'
            elsif agreements == 1
               visitor.first_or_create
               vote_mail.remaining_agreement = total - agreements
               mail_view vote_mail
               mail 'postulation/first_approbation'
            else
               vote_mail.remaining_agreement = total - agreements
               mail_view vote_mail
               mail 'postulation/approbation'
            end
         elsif vote.refusal?
            postulation.update_attribute :status, 1
            mail_view vote_mail
            mail 'postulation/refus'
         elsif vote.message.present?
            mail_view vote_mail
            mail 'postulation/fausse_approbation'
         end
      end
   end
end
