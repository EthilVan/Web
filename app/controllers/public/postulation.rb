class EthilVan::App

   get '/postulation/formulaire' do
      postulation = Postulation.new
      postulation.screens = (1..3).map { PostulationScreen.new }
      view Views::Public::Postulation::Formulaire.new postulation
      mustache 'public/postulation/formulaire'
   end

   post '/postulation/formulaire' do
      postulation = Postulation.new params[:postulation]
      if postulation.save
         view Views::Public::Postulation::Validation.new
         mustache 'public/postulation/validation'
      else
         view Views::Public::Postulation::Formulaire.new postulation
         mustache 'public/postulation/formulaire'
      end
   end
end
