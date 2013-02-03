ENV['RACK_ENV'] = 'test'

ARGV.clear
require './app/boot/app'

require 'minitest/spec'
require 'minitest/autorun'
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

module DatabaseTest

   module Helpers

      def setup
         DatabaseCleaner.start
      end

      def teardown
         DatabaseCleaner.clean
      end
   end

   class Spec < MiniTest::Spec

      include Helpers
   end
end
