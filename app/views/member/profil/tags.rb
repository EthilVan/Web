#encoding: utf-8

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
               date: tag.created_at.strftime('%d/%m/%Y à %H:%M')
            } }
         end
      end
   end
end
