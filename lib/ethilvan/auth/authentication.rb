module EthilVan::Authentication

   def self.registered(app)
      app.helpers Helpers
      app.set :pseudo_cookie_name, 'auth_pseudo'
      app.set :token_cookie_name,  'auth_token'
      app.set :remember_for, 1.month
   end

   module Helpers

      def logged_in?
         current_account.logged_in?
      end

      def current_account
         @current_account ||= find_current_account
      end

      def login(pseudo, token , remember)
         obf_pseudo = CaesarCipher.obfuscate(pseudo)
         expires = remember ? settings.remember_for.from_now : nil
         set_cookie(settings.pseudo_cookie_name, obf_pseudo, expires)
         set_cookie(settings.token_cookie_name,  token,      expires)
      end

      def logout
         delete_cookie(settings.pseudo_cookie_name)
         delete_cookie(settings.token_cookie_name)
      end

   private

      def find_current_account
         pseudo = request.cookies[settings.pseudo_cookie_name]
         pseudo &&= CaesarCipher.deobfuscate(pseudo)
         token = request.cookies[settings.token_cookie_name]
         authenticate(pseudo, token)
      end
   end

   class CaesarCipher

      OFFSET = 5

      def self.obfuscate(string)
         string.bytes.each_with_object('') do |byte, obfuscated|
            obfuscated << (byte + OFFSET).chr
         end + '$' + SecureRandom.base64(10)
      end

      def self.deobfuscate(string)
         string.bytes.each_with_object('') do |byte, deobfuscated|
            break(deobfuscated) if byte == 36
            deobfuscated << (byte - OFFSET).chr
         end
      end
   end
end
