if RUBY_PLATFORM == 'java'
   console = :irb
else
   console = :pry
end

task :console => 'console:env'
namespace :console do
   task :env => "#{console}:env"
   task :db => "#{console}:db"
   task :app => "#{console}:app"
end

def load_pry
   require 'pry'
   Pry.config.prompt = [
      proc { |obj, nest_level, _| "#{obj} (#{nest_level}) >> " },
      proc { |obj, nest_level, _| "#{obj} (#{nest_level}) << " }
   ]
   EthilVan.pry
end

namespace :pry do

   task :env do
      load_pry
   end

   task :db do
      require './app/database'
      load_pry
   end

   task :app do
      require './app/app'
      load_pry
   end
end

namespace :irb do

   task :env do
      system 'irb -r./app/env'
   end

   task :db do
      system 'irb -r./app/database'
   end

   task :app do
      system 'irb -r./app/app'
   end
end
