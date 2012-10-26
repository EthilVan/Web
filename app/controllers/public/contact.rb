class EthilVan::App

   get '/contact' do
      view Views::Public::Contact::Index.new
      mustache 'public/contact/index'
   end

   post '/contact' do
      email = EthilVan::ContactEmail.new(params.extract!(
            "name", "email", "category", "subject", "message"))
      if email.valid?
         puts "Envoi de l'email de contact !"
         redirect '/'
      else
         view Views::Public::Contact::Index.new email
         mustache 'public/contact/index'
      end
   end
end
