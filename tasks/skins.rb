task :install => 'skins:update'
task :clean   => 'skins:clean'
task :cron    => 'skins:update'

namespace :skins do

   task :update do
      require './app/boot/env'
      require 'ethilvan/skins'
      require 'ethilvan/skins/updater'
      EthilVan::Skins::Updater.update_all
   end

   task :clean do
      FileUtilsV.rm_rf 'tmp/skins'
   end
end
