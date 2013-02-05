require 'fileutils'
require 'securerandom'

module EthilVan::Cron

   @tasks = []

   def self.registered(app)
      tasks = @tasks
      app.helpers Helpers
      Helpers.write_token
      app.get('/cron') { run_cron(params, tasks) }
   end

   module Helpers

      extend self

      CRON_FILE = 'tmp/cron'

      def read_token
         File.read CRON_FILE
      end

      def write_token
         FileUtils.mkdir_p File.dirname CRON_FILE
         File.open(CRON_FILE, 'w') do |f|
            f << SecureRandom.urlsafe_base64(1000)
         end
      end

      def run_cron(params, tasks)
         halt(401) unless params[:token] == read_token
         write_token
         tasks.each { |task| task.call }
         halt(200)
      end
   end

   def self.task(task = nil, &block)
      @tasks << (task.nil? ? (block_given? ? block : nil) : task)
   end
end
