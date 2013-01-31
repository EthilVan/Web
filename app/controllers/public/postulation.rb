class EthilVan::App

   get '/postulation/formulaire' do
      postulation = Postulation.new
      view Views::Public::Postulation::Formulaire.new postulation
      mustache 'public/postulation/formulaire'
   end

   post '/postulation/formulaire' do
      postulation = Postulation.new(params[:postulation])
      postulation.valid?
      view Views::Public::Postulation::Formulaire.new postulation
      mustache 'public/postulation/formulaire'
   end
end
