def jobs_pidfile
   EthilVan::Config.jobs_pidfile
end

def poll_jobs(daemonize = false)
   require './app/boot/app'

   if daemonize
      Process.daemon
      File.open(jobs_pidfile, 'w') do |f|
         f << Process.pid
      end
   else
      puts 'Polling jobs ...'
   end

   EthilVan::Jobs.run
end

task :jobs do
   poll_jobs
end

task jobsd: 'jobsd:run'
namespace :jobsd do

   task :run do
      poll_jobs true
   end

   task :stop do
      require './app/boot/env'
      unless File.exists? jobs_pidfile
         exit 1
      end

      pid = File.read(jobs_pidfile).to_i
      Process.kill("INT", pid)
      File.delete(jobs_pidfile)
   end
end
