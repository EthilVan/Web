# -*- encoding: utf-8 -*-

###
# ** Hacky **
# Redéfinition de la méthode Template#render from
# scratch pour y inclure le header d'encoding et
# éviter les bugs imcompréhensibles !
class Mustache

   class Template

      def render(context)
         compiled = "def render(ctx) #{compile} end"
         instance_eval(compiled, __FILE__, __LINE__ - 1)
         render context
      end
   end
end
