task :clean => :clean_skins

task :clean_skins do
   FileUtilsV.rm_rf 'tmp/skins'
end
