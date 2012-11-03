require './config/app'

require 'test/unit'
require 'rack/test'
require 'factory_girl'

Dir["test/{factories,helpers}/*.rb"].each do |factory|
   require './' + factory.gsub(/\.rb$/, "")
end

class MiniTest::Unit::TestCase
   include Rack::Test::Methods

   def app
      EthilVan::App.new
   end

   # Models Helpers
   def _assert_valid(model, field)
      model.valid?
      assert_empty model.errors[field]
   end

   def _refute_valid(model, field)
      model.valid?
      refute_empty model.errors[field]
   end

   def assert_valid(model, field, *args)
      if args.empty?
         _assert_valid(model, field)
      elsif args.size > 1
         raise ArgumentError,
            "Too many arguments, expected 2 or 3, got #{2 + args.size}"
      else
         old_value = model.send field
         model.send("#{field}=", args.first)
         _assert_valid model, field
         model.send("#{field}=", old_value)
      end
   end

   def refute_valid(model, field, *args)
      if args.empty?
         _refute_valid(model, field)
      elsif args.size > 1
         raise ArgumentError,
               "Too many arguments, expected 2 or 3, got #{2 + args.size}"
      else
         old_value = model.send field
         model.send("#{field}=", args.first)
         _refute_valid model, field
         model.send("#{field}=", old_value)
      end
   end

   # Controllers Helpers
   alias response last_response

   def login(name, password)
      post "/membre/login",
            :name => name,
            :password => password
   end

   def logout
      get "/membre/logout"
   end
end

ActiveRecord::ConnectionAdapters::Mysql2Adapter.class_eval do
   def truncate(table_name)
      execute("TRUNCATE TABLE #{table_name}")
   end
end

ActiveRecord::Base.class_eval do
   def self.truncate
      connection.truncate(table_name)
   end
end
