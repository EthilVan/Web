require 'fileutils'
FileUtilsV = FileUtils::Verbose
require_relative 'app/env'

task :default => :pry
task :console
task :install
task :clean => :clean_skins

task :clean_skins do
   FileUtilsV.rm_rf 'tmp/skins'
end

require_relative 'tasks/console'
require_relative 'tasks/database'
require_relative 'tasks/assets'

task :test do
   system "RACK_ENV='test' ruby ./test/run.rb"
end
