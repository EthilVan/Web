require './app/app'

ARGV.clear
require 'test/unit'
require 'minitest/spec'
require 'factory_girl'
require 'database_cleaner'

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
