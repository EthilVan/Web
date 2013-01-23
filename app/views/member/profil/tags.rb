module EthilVan::App::Views

   module Member::Profil

      class Tags < Partial

         def initialize(tags)
            @tags = tags
         end

         def tags?
            @tags.present?
         end

         def tags
            @tags.map { |tag| {
               contents: tag.contents,
               tagger: tag.tagger.name,
               date: I18n.l(tag.created_at)
            } }
         end
      end
   end
end
