class EthilVan::App < Sinatra::Base

   get '/login/oublie/?' do
      view Views::Public::ForgottenPassword::Create.new
      mustache 'public/forgotten_password/create'
   end

   post '/login/oublie/?' do
      email = params[:fp_email]
      account = Account.where(email: email).first
      if account.nil?
         view Views::Public::ForgottenPassword::Create.new email, true
         mustache 'public/forgotten_password/create'
      else
         fp = ForgottenPassword.create_for account
         mail_view Views::Mails::ForgottenPassword.new(fp)
         mail 'forgotten_password'
         view Views::Public::ForgottenPassword::MailSent.new
         mustache 'public/forgotten_password/mail_sent'
      end
   end

   get %r{/login/oublie/(.{254})/?$} do |token|
      fp = resource ForgottenPassword.where(token: token).first
      not_found if fp.expired?
      view Views::Public::ForgottenPassword::NewPassword.new fp.account
      mustache 'public/forgotten_password/new_password'
   end

   post %r{/login/oublie/(.{254})/?$} do |token|
      fp = resource ForgottenPassword.where(token: token).first
      not_found if fp.expired?

      account = fp.account
      attributes = params[:account]
      fp.account.password = attributes[:password]
      fp.account.password_confirmation = attributes[:password_confirmation]

      if account.save
         fp.destroy
         view Views::Public::ForgottenPassword::Validation.new
         mustache 'public/forgotten_password/validation'
      else
         view Views::Public::ForgottenPassword::NewPassword.new account
         mustache 'public/forgotten_password/new_password'
      end
   end
end
