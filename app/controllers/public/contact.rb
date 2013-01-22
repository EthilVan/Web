class EthilVan::App

   get '/contact' do
      view Views::Public::Contact::Index.new
      mustache 'public/contact/index'
   end

   post '/contact' do
      email = ContactEmail.new(params.extract!(
            'name', 'email', 'category', 'subject', 'message'))
      if email.valid?
         mail do
            from     email.sender
            to       EthilVan::Config.mail_contact
            subject  email.categorized_subject
            body     email.body
         end
         redirect '/'
      else
         view Views::Public::Contact::Index.new email
         mustache 'public/contact/index'
      end
   end
end
