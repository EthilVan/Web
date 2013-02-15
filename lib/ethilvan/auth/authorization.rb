module EthilVan::Authorization

   def self.registered(app)
      app.set :login_path, "/login"
      app.set :after_login_cookie_name, 'after_login'

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
      app.helpers Helpers
      app.helpers EthilVan::AuthHelpers
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
         redirect_path = request.cookies[settings.after_login_cookie_name]
         return if redirect_path.nil?
         delete_cookie(settings.after_login_cookie_name)
         redirect redirect_path
      end

      def ensure_logged_in
         return if logged_in?
         not_authorized if request.xhr?
         set_cookie(settings.after_login_cookie_name, request.path)
         redirect settings.login_path
      end

      def ensure_authorized(role)
         ensure_logged_in
         return if current_account.role.inherit?(role)
         not_authorized
      end

      def not_authorized
         halt 401
      end
   end
end
