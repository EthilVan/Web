task :cron_web do
   require 'net/http'
   require 'yaml'
   require './lib/ethilvan/cron'

   puts 'Triggering website cron tasks ... '
   port = YAML.load_file('config.yml')['port'] || 9180
   token = EthilVan::Cron.read_token
   uri = URI("http://localhost:#{port}/cron?token=#{token}")
   response = Net::HTTP.get_response(uri)
   puts response.code == '200' ? 'Ok' : "Failed (#{response.code})"
end

task :cron => :cron_web
