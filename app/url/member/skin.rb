module EthilVan

   module Url::Member

      module Skin

         extend self

         def avatar(account)
            "/avatar/#{account.name}.png"
         end

         def private_skin(account, type, scale)
            "/membre/skin/#{account.name}_#{type}_x#{scale}.png"
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
