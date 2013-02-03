require_relative '../helpers'
require 'rack/test'

class MiniTest::Unit::TestCase

   include Rack::Test::Methods

   def app
      EthilVan::App.new
   end

   alias response last_response

   def login(user, &block)
      name = user.is_a?(Account) ? user.name : user
      post '/login', 'login[name]' => name, 'login[password]' => 'password'
      if block_given?
         block.call
         logout
      end
      name
   end

   def logout
      get "/membre/logout"
   end
end
