module EthilVan::Authorization

   AFTER_LOGIN_KEY = 'Iino2yBxlYqY0FaRImfk'

   def self.registered(app)
      app.set :login_path, "/login"

      class << app
         attr :logged_only_paths
         attr :protected_paths
      end
      app.instance_variable_set :@logged_only_paths, []
      app.instance_variable_set :@protected_paths, []

      app.before do
         self.class.logged_only_paths.each do |path|
            ensure_logged_in if request.path =~ path
         end
         self.class.protected_paths.each do |path, role|
            ensure_authorized role if request.path =~ path
         end
      end

      app.extend ClassHelpers
      app.send :include, Helpers
   end

   module ClassHelpers

      def logged_only(path)
         logged_only_paths << path
      end

      def protect(path, role)
         protected_paths << [path, role]
      end
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
