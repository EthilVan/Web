require_relative 'config/env'

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
   system 'irb -r./config/env'
end

task :install => 'db:migrate'
task :install => 'assets:install'
task :install => 'assets:compile'

rrequire 'lib/tasks/database'
rrequire 'lib/tasks/assets/assets'

task :test do
   system "RACK_ENV='test' ruby ./test/run.rb"
end
