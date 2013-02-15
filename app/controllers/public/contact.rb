class EthilVan::App

   get '/contact' do
      view Views::Public::Contact::Index.new
      mustache 'public/contact'
   end

   post '/contact' do
      email = ContactEmail.new(params[:contact_email])
      if email.valid?
         mail do
            from     email.sender
            to       email.receiver
            subject  email.categorized_subject
            body     email.body
         end
         view Views::Public::Contact::Index.new ContactEmail.new, true
         mustache 'public/contact'
      else
         view Views::Public::Contact::Index.new email
         mustache 'public/contact'
      end
   end
end
