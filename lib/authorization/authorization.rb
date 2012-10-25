module EthilVan::Authorization

   AFTER_LOGIN_KEY = 'Iino2yBxlYqY0FaRImfk'

   def self.registered(app)
      app.set :login_path, "/login"
      app.send :include, Helpers
   end

   module Helpers

      def redirect_after_login
         unless session[AFTER_LOGIN_KEY].nil?
            redirect session[AFTER_LOGIN_KEY]
            session[AFTER_LOGIN_KEY] = nil
         end
      end

      def ensure_logged_in
         if !logged_in?
            session[AFTER_LOGIN_KEY] = request.path
            redirect settings.login_path
         end
      end

      def ensure_authorized(role)
         ensure_logged_in
         halt 401 if !current_account.role.inherit?(role)
      end
   end
end
