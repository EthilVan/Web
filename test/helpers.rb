ENV['RACK_ENV'] = 'test'

ARGV.clear
require 'minitest/spec'
require 'minitest/autorun'

require 'factory_girl'
require 'database_cleaner'

require './app/boot/app'

module BCrypt

   class PlainPassword < String

      def self.create(password, *args)
         new(password[0...20])
      end

      def ==(other)
         return false unless other.is_a? String
         super(other[0...20])
      end
      alias is_password? ==
   end

   remove_const :Password
   Password = PlainPassword
end

DatabaseCleaner.clean_with :truncation
require_relative 'fixtures'
DatabaseCleaner.strategy = :transaction
