module EthilVan::App::Views

   module Gestion::Postulation

      class List < Page

         def initialize(postulations)
            @postulations = postulations.group_by &:status
         end

         def map(data)
            data.map { |postulation| {
               name: postulation.name,
               date: I18n.l(postulation.created_at.to_date),
               url: urls::Gestion::Postulation.show(postulation.name)
            } }
         end

         def postulations?
            @postulations[0].present?
         end

         def postulations
             map(@postulations[0])
         end

         def vetoed?
            @postulations[1].present?
         end

         def vetoed
             map(@postulations[1])
         end

         def validated?
            @postulations[2].present?
         end

         def validated
             map(@postulations[2])
         end
      end
   end
end
