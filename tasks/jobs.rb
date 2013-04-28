task :jobs do
   require './app/boot/app'
   puts 'Polling jobs ...'
   EthilVan::Jobs.run
end
