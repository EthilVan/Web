module EthilVan

   module Url

      module Sinatra

         def self.registered(app)
            app.helpers Helpers
         end

         module Helpers

            def urls
               Url
            end
         end
      end

      module Public
      end

      module Member
      end

      module Gestion
      end
   end
end

require_all 'app/url'
