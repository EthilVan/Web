# -*- encoding: utf-8 -*-

class Mustache

   class CachedTemplate < Template

      def render(context)
         compiled = "def render(ctx) #{compile} end"
         instance_eval(compiled, __FILE__, __LINE__ - 1)
         # Free @source since we do no longer need it
         @source = nil
         render context
      end
   end
end
