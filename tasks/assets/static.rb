require 'fileutils'

module EthilVan::Static

   def self.install
      return unless EthilVan.production?

      puts "Creating buster directory '#{BUSTER_DIR}'"
      Dir[File.join(SOURCE_DIR, '/**/*')].each do |fullpath|
         next unless File.file? fullpath
         filepath = fullpath.gsub(/^#{SOURCE_DIR}\/?/, '')
         if BLACKLIST.any? { |r| filepath =~ r }
            move(fullpath, STATIC_DIR, filepath)
         else
            move(fullpath, BUSTER_DIR, filepath)
         end
      end
   end

   def self.move(fullpath, dir, filepath)
      dest = File.join(dir, filepath)
      FileUtils.mkdir_p File.dirname dest
      FileUtils.cp fullpath, dest
   end
end
