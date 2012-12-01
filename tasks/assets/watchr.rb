require 'watchr'

class EthilVan::Assets::Watchr < ::Watchr::Script

   def initialize(assets)
      super()
      @assets = assets
      watch_all
      puts 'Watching'
   end

   def watch_all
      reset

      Style.included_files.each do |file|
         watch(file) { Style.each &:compile }
      end

      @assets.each do |asset|
         watch asset.manifest do
            watch_all
            asset.each &:compile
         end
      end

      assets_by_file.each do |file, assets|
         watch(file) { assets.each &:compile }
      end
   end

private

   def assets_by_file
      @assets.each_with_object({}) do |asset, hash|
         asset.files.each do |file|
            hash[file] ||= []
            hash[file] << asset
         end
      end
   end
end
