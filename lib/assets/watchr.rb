require 'watchr'
rrequire 'lib/assets/assets'

class EthilVan::Assets::Watchr < ::Watchr::Script

   def initialize(assets)
      super()

      assets.each do |asset|
         watch asset.manifest_path do
            watch_asset_files asset
            asset.compile
         end
         watch_asset_files asset
      end

      puts 'Watching'
   end

   def watch_asset_files(asset)
      asset.manifest.each do |file|
         watch file do |md|
            asset.compile
         end
      end
   end
end
