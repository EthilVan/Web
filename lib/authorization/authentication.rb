require 'sinatra/cookies'

module EthilVan::Authentication

   COOKIE_TOKEN_NAME = :nimtUIhcDW02mord147Y

   def self.registered(app)
      app.helpers Sinatra::Cookies
      app.send :include, Helpers
      app.set :remember_for, 1.month
   end

   module Helpers

      def logged_in?
         !current_account.nil?
      end

      def current_account
         @current_account ||= find_current_account
      end

      def login(auth_token, remember)
         if remember
            default_expires = cookies.options[:expires]
            cookies.options[:expires] = Time.now + settings.remember_for
            cookies[COOKIE_TOKEN_NAME] = auth_token
            cookies.options[:expires] = default_expires
         else
            cookies[COOKIE_TOKEN_NAME] = auth_token
         end
      end

      def logout
         cookies[COOKIE_TOKEN_NAME] = nil
      end

   private

      def find_current_account
         token = cookies[COOKIE_TOKEN_NAME]
         return nil if token.nil?
         return Account.find_by_auth_token token
      end
   end
end
