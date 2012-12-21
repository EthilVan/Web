def load_pry_with(path)
   require path
   require 'pry'
   Pry.config.prompt = [
      proc { |obj, nest_level, _| "#{obj} (#{nest_level}) >> " },
      proc { |obj, nest_level, _| "#{obj} (#{nest_level}) << " }
   ]
   EthilVan.pry
end

task :console => 'console:db'
namespace :console do
   task(:env) { load_pry_with './app/boot/env' }
   task(:db)  { load_pry_with './app/boot/database' }
   task(:app) { load_pry_with './app/boot/app' }
end
