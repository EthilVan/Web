module EthilVan

   module Cookies

      def self.registered(app)
         app.helpers Helpers
      end

      module Helpers

         def set_cookie(name, value, expires = nil)
            hash = { path: '/', value: value }
            hash[:expires] = expires unless expires.nil?
            response.set_cookie(name, hash)
         end

         def delete_cookie(name)
            set_cookie(name, 'deleted', 1.minute.from_now)
         end
      end
   end
end
