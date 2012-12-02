require 'fileutils'
FileUtilsV = FileUtils::Verbose

task :default => :console
task :console
task :install
task :clean => :clean_skins

task :clean_skins do
   FileUtilsV.rm_rf 'tmp/skins'
end

require_relative 'tasks/console'
require_relative 'tasks/database'
require_relative 'tasks/assets'
require_relative 'tasks/test'
