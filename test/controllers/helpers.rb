require_relative '../helpers'
require 'rack/test'

class MiniTest::Unit::TestCase

   include Rack::Test::Methods

   def app
      EthilVan::App.new
   end

   alias response last_response

   def login(name, password)
      post "/login", name: name, password: password
   end

   def logout
      get "/membre/logout"
   end
end
