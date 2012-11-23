task :install => 'jruby:install'

BaseUrl = 'http://cloud.github.com/downloads/EthilVan/jruby-markdown/'
JarName = 'jruby-markdown-dev.jar'

namespace :jruby do

   task :install => 'install:markdown'
   namespace :install do

      task :markdown do
         require 'net/http'
         uri = URI(BaseUrl + JarName)
         path = EthilVan.path('lib', 'markdown', 'jruby-markdown.jar')
         puts 'Downloading ' + path + ' from ' + uri.to_s
         Net::HTTP.start(uri.host, uri.port) do |http|
            request = Net::HTTP::Get.new uri.request_uri

            http.request request do |response|
               unless response.code == '200'
                  puts "Unable to download markdown jar. (#{response.code})"
                  exit 1
               end
               File.open path, 'wb' do |io|
                  response.read_body { |chunk| io.write chunk }
               end
            end
         end
      end
   end
end
