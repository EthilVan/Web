require 'securerandom'
require 'sinatra/cookies'

module EthilVan::Authentication

   COOKIE_PSEUDO_NAME = :CYd1Zj6wab9ff1K8gbWNu4cJLQtjqg5MJgGbCI
   COOKIE_TOKEN_NAME =  :IZq3tuP6qQbHwflEXoLByl3sJGZ2n4tjMdWZA5

   def self.registered(app)
      app.helpers Sinatra::Cookies
      app.send :include, Helpers
      app.set :remember_for, 1.month
   end

   module Helpers

      def logged_in?
         current_account.logged_in?
      end

      def current_account
         @current_account ||= find_current_account
      end

      def current_account=(account)
         warn "Bypassing authentication !" unless EthilVan.test?
         @current_account = account
      end

      def login(account, remember)
         pseudo = CaesarCipher.obfuscate(account.name)
         auth_token = account.generate_auth_token
         if remember
            default_expires = cookies.options[:expires]
            cookies.options[:expires] = Time.now + settings.remember_for
            cookies[COOKIE_PSEUDO_NAME] = pseudo
            cookies[COOKIE_TOKEN_NAME]  = auth_token
            cookies.options[:expires] = default_expires
         else
            cookies[COOKIE_PSEUDO_NAME] = pseudo
            cookies[COOKIE_TOKEN_NAME]  = auth_token
         end
      end

      def logout
         account.delete_auth_token
         cookies[COOKIE_PSEUDO_NAME] = nil
         cookies[COOKIE_TOKEN_NAME] = nil
      end

   private

      def find_current_account
         pseudo = cookies[COOKIE_PSEUDO_NAME]
         return Guest if pseudo.nil?
         pseudo = CaesarCipher.deobfuscate(pseudo)
         token = cookies[COOKIE_TOKEN_NAME]
         return Guest if token.nil?
         account = Account.authenticate_by_token(pseudo, token)
         account.nil? ? Guest : account
      end
   end

   Guest = Object.new
   def Guest.logged_in?
      false
   end

   class CaesarCipher

      OFFSET = 5

      def self.obfuscate(string)
         string.bytes.inject('') do |obfuscated, byte|
            obfuscated << (byte + OFFSET).chr
         end + '$' + SecureRandom.base64(10)
      end

      def self.deobfuscate(string)
         string.bytes.inject('') do |deobfuscated, byte|
            break(deobfuscated) if byte == 36
            deobfuscated << (byte - OFFSET).chr
         end
      end
   end
end
