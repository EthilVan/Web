module EthilVan::App::Views

   module Public::News

      class Images < Partial

         attr :private_icon
         attr :banners

         def initialize(private_icon, banners)
            @private_icon = private_icon
            @banners = banners
         end
      end
   end
end
