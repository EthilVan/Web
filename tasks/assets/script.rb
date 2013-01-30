require 'closure-compiler'

module EthilVan::Assets

   class Script < Base

      DirName = 'scripts'
      OutputExt = 'js'

      def compile?(file)
         File.extname(file) == '.ts'
      end

      # TODO: Trouvé comment gérer les erreurs du compilateur.
      def compile_asset(file, dest)
         system "tsc --out #{dest} #{file}"
         true
      end

      def compress(source)
         compiler = Closure::Compiler.new(
               compilation_level: 'SIMPLE_OPTIMIZATIONS')
         return compiler.compile(source)
      end
   end
end
