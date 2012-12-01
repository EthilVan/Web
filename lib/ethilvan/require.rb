module Kernel

   def require_all(dir)
      failed = Dir["./#{dir}/**/*.rb"]
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
