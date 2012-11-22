task :install => 'db:migrate'

namespace :db do

   task :migrate do
      require 'logger'
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveRecord::Migration.verbose = true
      ActiveRecord::Migrator.migrate('database/migrations')
   end
end
