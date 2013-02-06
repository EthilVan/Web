require 'fileutils'
require 'securerandom'

module EthilVan

   module Cron

      @tasks = []

      class << self

         TOKEN_FILE = 'tmp/cron'

         def read_token
            File.read TOKEN_FILE
         end

         def write_token
            FileUtils.mkdir_p File.dirname TOKEN_FILE
            File.open(TOKEN_FILE, 'w') do |f|
               f << SecureRandom.urlsafe_base64(1000)
            end
         end

         def run(token)
            return false unless token == read_token
            write_token
            @tasks.each &:call
            return true
         end

         def task(task = nil, &block)
            @tasks << (task.nil? ? (block_given? ? block : nil) : task)
         end
      end

      module Sinatra

         def self.registered(app)
            Cron.write_token
            app.get('/cron') do
               Cron.run(params[:token]) ? 200 : 401
            end
         end
      end
   end
end
