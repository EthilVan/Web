task :assets => 'assets:compile'
namespace :assets do

   task :require_files do
      rrequire 'lib/tasks/assets/base'
      rrequire 'lib/tasks/assets/style'
      rrequire 'lib/tasks/assets/script'
      rrequire 'lib/tasks/assets/watchr'
      include EthilVan::Assets
   end

   task :install => 'install:emoji'
   namespace :install do
      task :emoji do
         rrequire 'lib/tasks/emoji_install'
         EthilVan::Emoji.install
      end
   end

   task :compile => 'compile:style'
   task :compile => 'compile:script'
   namespace :compile do
      task :style => :require_files do
         Style.each &:compile
      end
      task :script => :require_files do
         Script.each &:compile
      end
   end

   task :watch => :compile do
      watchr = EthilVan::Assets::Watchr.new(Style.all + Script.all)
      controller = ::Watchr::Controller.new(
            watchr, ::Watchr.handler.new)
      controller.run
   end

   task :clean => :require_files do
      FileUtils.rm_rf Base::CACHE
      Style.each { |style| FileUtils.rm_f style.output_file }
      Script.each { |style| FileUtils.rm_f style.output_file }
   end
end
