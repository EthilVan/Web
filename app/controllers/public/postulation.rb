class EthilVan::App

   get '/postulation/formulaire' do
      postulation = Postulation.new
      postulation.screens = (1..3).map { PostulationScreen.new }
      view Views::Public::Postulation::Formulaire.new postulation
      mustache 'public/postulation/formulaire'
   end

   post '/postulation/formulaire' do
      param = params[:postulation]
      param[:screens] = param[:screens].map do |hash|
         PostulationScreen.new(hash)
      end
      postulation = Postulation.new(param)
      postulation.valid?
      view Views::Public::Postulation::Formulaire.new postulation
      mustache 'public/postulation/formulaire'
   end
end
