module EthilVan::App::Views

   module Public

      class About < Page

         def team
            EthilVan::About['team']
         end

         def components
            EthilVan::About['components']
         end

         def stack
            EthilVan::About['stack']
         end

         def softwares
            EthilVan::About['softwares']
         end
      end
   end
end
