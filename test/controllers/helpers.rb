require_relative '../helpers'
require 'rack/test'

class MiniTest::Unit::TestCase

   include Rack::Test::Methods

   def app
      EthilVan::App.new!
      #Sinatra::Wrapper.new(@ethilvan.build(@ethilvan).to_app, @ethilvan)
   end

   #def ethilvan
   #   @ethilvan
   #end

   alias response last_response

   def login(account)
      app.current_account = account
   end

   def logout
      get "/membre/logout"
   end
end
