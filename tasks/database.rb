task :install => 'db:migrate'

namespace :db do

   task :migrate do
      require './app/database'
      require 'logger'
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveRecord::Migration.verbose = true

      version = ENV['version']
      version = version.to_i unless version.nil?
      ActiveRecord::Migrator.migrate('tasks/migrations', version)
   end

   task :console do
      require './app/database'
      config = ActiveRecord::Base.configurations[EthilVan::ENV]
      command =  'mysql'
      command << " -h #{config['host']}"
      command << " -u #{config['username']}"
      command << " --password=#{config['password']}"
      command << " #{config['database']}"

      system command
   end
end
