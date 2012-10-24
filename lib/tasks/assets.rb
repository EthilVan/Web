rrequire_dir 'lib/tasks/assets'

module EthilVan::Assets
   @list = [ Style.new('app'), Script.new('app')]

   def self.compile
      @list.each { |asset| asset.compile }
   end

   def self.watch
      watchr = Watchr.new @list
      controller = ::Watchr::Controller.new(watchr, ::Watchr.handler.new)
      controller.run
   end
end
