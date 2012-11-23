task :install => 'db:migrate'

namespace :db do

   task :migrate do |t|
      require 'logger'
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      ActiveRecord::Migration.verbose = true

      version = ENV['version']
      version = version.to_i unless version.nil?
      ActiveRecord::Migrator.migrate('database/migrations', version)
   end
end
