def load_tests(*directories)
   ENV['RACK_ENV'] = 'test'
   Dir["./test/{#{directories * ','}}/test_*.rb"].each do |file|
      require file
   end
end

task :test => 'test:all'

namespace :test do

   task :models do
      load_tests 'models'
   end

   task :controllers do
      load_tests 'controllers'
   end

   task :all do
      load_tests '*'
   end
end
