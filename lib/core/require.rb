module Kernel

   def rrequire(path)
      require "./#{path}"
   end

   def rrequire_dir(dir)
      Dir["#{dir}/*.rb"].each do |filepath|
         rrequire filepath
      end
   end

   def rrequire_all(dir)
      Dir["#{dir}/**/*.rb"].each do |filepath|
         rrequire filepath
      end
   end
end
