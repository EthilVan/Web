require 'watchr'

class EthilVan::Assets::Watchr < ::Watchr::Script

   def initialize(assets)
      super()

      Style.included_files.each do |file|
         watch file do
            Style.each &:compile
         end
      end

      assets.each do |asset|
         watch asset.manifest do
            watch_asset_files asset
            asset.compile
         end
         watch_asset_files asset
      end

      puts 'Watching'
   end

   def watch_asset_files(asset)
      asset.files.each do |file|
         watch file do |md|
            asset.compile
         end
      end
   end
end
