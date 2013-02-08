task :install => 'assets:install'
task :clean => 'assets:clean'

task :assets => 'assets:compile'
namespace :assets do

   task :init do
      require './app/boot/env'
      require_relative 'assets/base'
      require_relative 'assets/style'
      require_relative 'assets/script'
      include EthilVan::Assets
   end

   task :install => ['install:emoji', :compile, 'install:static']
   namespace :install do

      task :emoji => :init
      task :emoji do
         require_relative 'assets/emoji'
         puts 'Installation des emojis'
         EthilVan::Emoji.install
      end

      task :static do
         require './app/boot/env'
         require_relative 'assets/static'
         EthilVan::Static.install
      end
   end

   task :compile => 'compile:style'
   task :compile => 'compile:script'
   namespace :compile do

      task :style => :init do
         Style.each &:compile
      end
      task :script => :init do
         Script.each &:compile
      end
   end

   task :watch => :compile do
      require_relative 'assets/watchr'
      watchr = EthilVan::Assets::Watchr.new(Style.all + Script.all)
      controller = ::Watchr::Controller.new(watchr, ::Watchr.handler.new)
      controller.run
   end

   task :clean => 'clean:emoji'
   task :clean => 'clean:style'
   task :clean => 'clean:script'
   task :clean => 'clean:static'
   namespace :clean do

      task :emoji => :init do
         glob = File.join(EthilVan::Emoji.images_path, '*.png')
         puts "rm -f #{glob}"
         FileUtils.rm_f Dir[glob]
      end
      task :style => :init do
         FileUtilsV.rm_rf File.join(Base::CACHE, 'style')
         Style.each { |style| FileUtilsV.rm_f style.output_file }
      end
      task :script => :init do
         FileUtilsV.rm_rf File.join(Base::CACHE, 'scripts')
         Script.each { |style| FileUtilsV.rm_f style.output_file }
      end
      task :static => :init do
         FileUtilsV.rm_rf EthilVan::Static::PRODUCTION_DIR
      end
      task :cache => :init do
         FileUtilsV.rm_rf Base::CACHE
      end
   end

   task :reinstall => :clean
   task :reinstall => :install
end
