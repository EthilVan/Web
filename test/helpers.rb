require './app/app'

ARGV.clear
require 'test/unit'
require 'minitest/spec'
require 'factory_girl'

require_relative 'helpers'

Dir["test/fixtures/*.rb"].each do |factory|
   require './' + factory.gsub(/\.rb$/, "")
end
