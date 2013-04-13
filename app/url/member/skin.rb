module EthilVan

   module Url::Membre

      module Skin

         extend self

         def avatar(account)
            "/avatar/#{account.name}"
         end

         def private_skin(account, type, scale)
            "/membre/skin/#{account.name}_#{type}x#{scale}.png"
         end

         def preview(account, scale)
            private_skin(account, 'preview', scale)
         end

         def head(account, scale)
            private_skin(account, 'head', scale)
         end
      end
   end
end
