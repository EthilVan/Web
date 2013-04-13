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
            urls::Gestion::Announce.edit(@model)
         end

         def delete_url
            urls::Gestion::Announce.delete(@model)
         end

         def author
            @model.account.name
         end

         def author_url
            urls::Member::Profil.general(@model.account)
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
