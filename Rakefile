require 'fileutils'
FileUtilsV = FileUtils::Verbose

task :default => :console
task :console
task :install
task :clean
task :cron

require_relative 'tasks/console'
require_relative 'tasks/cron'
require_relative 'tasks/database'
require_relative 'tasks/test'
require_relative 'tasks/assets'
require_relative 'tasks/skins'
