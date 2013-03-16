module EthilVan::App::Views

   module Gestion::Announce

      class Entry < Partial

         def initialize(model)
            @model = model
         end

         def anchor
            "annonce-#{@model.id}"
         end

         def edit_url
            "/gestion/annonce/#{@model.id}/editer"
         end

         def delete_url
            "/gestion/annonce/#{@model.id}/supprimer"
         end

         def author
            @model.account.name
         end

         def author_url
            urls.profil(@model.account)
         end

         def author_avatar
            @model.account.profil.avatar_url
         end

         def content
            @model.parsed_content
         end

         def date
            I18n.l @model.created_at
         end
      end
   end
end
