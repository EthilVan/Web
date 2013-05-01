require 'beanstalk-client'

module EthilVan::Jobs
end

class << EthilVan::Jobs

   def push(job)
      pool.put(Marshal.dump(job))
   rescue Beanstalk::NotConnected
      job.run
   end

   def run
      loop do
         queued_job = pool.reserve
         job = Marshal.load(queued_job.body)
         job.run
         queued_job.delete
      end
   end

private

   def pool
      @pool ||= Beanstalk::Pool.new([EthilVan::Config.jobs_url])
   end
end
