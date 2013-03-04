class EthilVan::App

   get '/postulation' do
      postulation = Postulation.new
      postulation.screens = (1..3).map { PostulationScreen.new }
      view Views::Public::Postulation::Formulaire.new postulation
      mustache 'public/postulation/tabs'
   end

   post '/postulation' do
      postulation = Postulation.new params[:postulation]
      if postulation.save
         view Views::Public::Postulation::Validation.new
         mustache 'public/postulation/validation'
      else
         File.open('tmp/invalid_postulations', 'a') do |f|
            f << "/*\n"
            f << " * Postulation Invalide :\n"
            f << " *  #{Time.now}\n"
            f << " */\n"
            json = postulation.to_json
            f << JSON.pretty_generate JSON.parse json
            f << "\n"
         end
         view Views::Public::Postulation::Formulaire.new postulation
         mustache 'public/postulation/tabs'
      end
   end
end
