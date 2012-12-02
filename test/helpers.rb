require './app/app'

ARGV.clear
require 'test/unit'
require 'minitest/spec'
require 'factory_girl'

require_relative 'helpers'

Dir["test/fixtures/*.rb"].each do |factory|
   require './' + factory.gsub(/\.rb$/, "")
end

class ActiveRecord::ConnectionAdapters::Mysql2Adapter

   def truncate(table_name)
      execute("TRUNCATE TABLE #{table_name}")
   end
end

class ActiveRecord::Base

   def self.truncate
      connection.truncate(table_name)
   end

   infect_an_assertion :assert_valid, :must_be_valid, true
   infect_an_assertion :assert_valid_with, :must_be_valid_with, true
   infect_an_assertion :refute_valid, :wont_be_valid, true
   infect_an_assertion :refute_valid_with, :wont_be_valid_with, true
end
