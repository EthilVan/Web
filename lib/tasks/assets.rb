rrequire_dir 'lib/assets'

module EthilVan::Assets
   @list = [
      Style.new('app'),
      Style.new('member'),
      Script.new('app'),
      Script.new('member')
   ]

   def self.compile
      @list.each { |asset| asset.compile }
   end

   def self.watch
      watchr = Watchr.new @list
      controller = ::Watchr::Controller.new(watchr, ::Watchr.handler.new)
      controller.run
   end
end
