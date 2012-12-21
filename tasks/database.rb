task :install => 'db:migrate'

MIGRATIONS_PATH = 'tasks/migrations'

namespace :db do

   task :migrate do
      require './app/boot/database'
      require 'logger'
      ActiveRecord::Migration.verbose = true

      if ENV['up'].nil?
         if ENV['down'].nil?
            version = ENV['version']
            version = version.to_i unless version.nil?
            ActiveRecord::Migrator.migrate(MIGRATIONS_PATH, version)
         else
            steps = ENV['down'].to_i
            ActiveRecord::Migrator.rollback(MIGRATIONS_PATH, steps)
         end
      else
         steps = ENV['up'].to_i
         ActiveRecord::Migrator.forward(MIGRATIONS_PATH, steps)
      end
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
