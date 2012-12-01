task :install => 'db:migrate'

namespace :db do

   task :migrate do |t|
      require './app/database'
      require 'logger'
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveRecord::Migration.verbose = true

      version = ENV['version']
      version = version.to_i unless version.nil?
      ActiveRecord::Migrator.migrate('tasks/migrations', version)
   end
end
