module EthilVan

   module Url::Member

      module Profil::Edit

         extend self

         def base(account)
            Profil.base(account) + '/editer'
         end

         def tabs
            %w{general preferences apparence compte}
         end

         def general(account)
            base(account) + '/general'
         end

         def preferences(account)
            base(account) + '/preferences'
         end

         def appearance(account)
            base(account) + '/apparence'
         end

         def account(account)
            base(account) + '/compte'
         end
      end
   end
end
