require 'net/http'

module EthilVan::Assets

   class Script < Base

      DirName = "scripts"
      OutputExt = "js"

      def compile?(file)
         File.extname(file) == ".ts"
      end

      # TODO: Trouvé comment gérer les erreurs du compilateur.
      def compile_asset(file, dest)
         system "tsc --out #{dest} #{file}"
         true
      end

      def compress(source)
         response = Net::HTTP.post_form(
            URI.parse("http://closure-compiler.appspot.com/compile"),
            output_info: "compiled_code",
            compilation_level: "SIMPLE_OPTIMIZATIONS",
            js_code: source
         )
         return response.body
      end
   end
end
