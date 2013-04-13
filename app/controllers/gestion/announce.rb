class EthilVan::App < Sinatra::Base

   get '/gestion/annonce/?' do
      announces = Announce.by_date
      view Views::Gestion::Announce::List.new announces
      mustache 'gestion/announce/list'
   end

   get '/gestion/annonce/creer/?' do
      announce = Announce.new
      announce.account = current_account

      view Views::Gestion::Announce::Create.new announce
      mustache 'gestion/announce/create'
   end

   post '/gestion/annonce/creer/?' do
      announce = Announce.new params[:announce]
      announce.account = current_account

      if announce.save
         redirect_not_xhr '/gestion/annonce'
         view Views::Gestion::Announce::Created.new announce
         mustache 'gestion/announce/created'
      else
         view Views::Gestion::Announce::Create.new announce
         mustache 'gestion/announce/create'
      end
   end

   get '/gestion/annonce/:id/editer/?' do |id|
      announce = resource Announce.find_by_id id

      view Views::Gestion::Announce::Edit.new announce
      mustache 'gestion/announce/edit'
   end

   post '/gestion/annonce/:id/editer/?' do |id|
      announce = resource Announce.find_by_id id

      if announce.update_attributes params[:announce]
         redirect_not_xhr '/gestion/annonce'
         view Views::Gestion::Announce::Entry.new announce
         mustache 'gestion/announce/_entry'
      else
         view Views::Gestion::Announce::Edit.new announce
         mustache 'gestion/announce/edit'
      end
   end

   get '/gestion/annonce/:id/supprimer/?' do |id|
      announce = resource Announce.find_by_id id
      announce.destroy
      xhr_ok_or_redirect '/gestion/annonce'
   end
end
