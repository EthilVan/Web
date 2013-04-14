class EthilVan::App < Sinatra::Base

   # Public
   get '/' do
      redirect logged_in? ? '/membre' : '/presentation/generale'
   end

   # Membre
   logged_only %r{^/membre}

   # Gestion
   protect %r{^/gestion/postulation}, EthilVan::Role::MODO
   protect %r{^/gestion/annonce},     EthilVan::Role::REDACTEUR
   protect %r{^/gestion/discussion},  EthilVan::Role::REDACTEUR
end
