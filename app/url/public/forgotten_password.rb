module EthilVan

   module Url::Public

      module ForgottenPassword

         extend self

         BASE = '/login/oublie'

         def index
            BASE
         end

         def token(token)
            "#{BASE}/#{token}"
         end
      end
   end
end
