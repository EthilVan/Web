def jobs_pidfile
   EthilVan::Config.jobs_pidfile
end

def poll_jobs(daemonize = false)
   require './app/boot/database'

   if daemonize
      Process.daemon
      File.open(jobs_pidfile, 'w') { |f| f << Process.pid }
      logfile = EthilVan::Config.jobs_logfile
      Logging.logger.root.appenders = Logging.appenders.file(logfile,
            layout: EthilVan::Logging.layout)
   else
      puts 'Polling jobs ...'
   end

   EthilVan::Jobs.run
end

task :jobs do
   poll_jobs
end

task jobsd: 'jobsd:start'
namespace :jobsd do

   task :start do
      poll_jobs true
   end

   task :status do
      require './app/boot/env'
      status = File.exists?(jobs_pidfile) ? "Running" : "Not Running"
      puts "Status : #{status}"
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

   task restart: [:stop, :start]
end
