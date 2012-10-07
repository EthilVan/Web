module Kernel

   def require_dir(dir)
      require_files "#{dir}/*.rb"
   end

   def require_rdir(dir)
      require_files "#{dir}/**/*.rb"
   end

   def rrequire(path)
      require "./#{path}"
   end

   def rrequire_dir(dir)
      require_files "./#{dir}/*.rb"
   end

   def rrequire_rdir(dir)
      require_files "./#{dir}/**/*.rb"
   end

private

   def remove_extname(file)
      File.basename(file, File.extname(file))
   end

   def require_files(pattern)
      failed = Dir[pattern]
      files = []
      first_name_error = nil

      until files.size == failed.size
         files = failed
         failed = []
         exc = nil

         files.each do |file|
            begin
               require file
            rescue NameError
               failed << file
               exc ||= $!
            end
         end
      end

      raise exc if failed.size > 0
   end
end
