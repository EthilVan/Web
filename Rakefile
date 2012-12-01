require_relative 'app/env'

task :default => :pry
task :pry do
   require 'pry'
   Pry.config.prompt = [
      proc { |obj, nest_level, _| "#{obj} (#{nest_level}) >> " },
      proc { |obj, nest_level, _| "#{obj} (#{nest_level}) << " }
   ]
   EthilVan.pry
end

task :irb do
   system 'irb -r./app/env'
end

task :install

rrequire 'lib/tasks/database'
rrequire 'lib/tasks/assets'

task :test do
   system "RACK_ENV='test' ruby ./test/run.rb"
end
