module EthilVan

   module Url::Member

      module Profil

         extend self

         BASE = '/membre'

         def base(account)
            "#{BASE}/@#{account.is_a?(String) ? account : account.name}"
         end

         def tabs
            %w{general postulation activites tags messages}
         end

         def show(account)
            general(account)
         end

         def general(account)
            base(account) + '/general'
         end

         def postulation(account)
            base(account) + '/postulation'
         end

         def activities(account)
            base(account) + '/activite'
         end

         def tags(account)
            base(account) + '/tags'
         end

         def messages(account)
            base(account) + '/messages'
         end
      end
   end
end
