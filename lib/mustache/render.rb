require 'mustache'

module EthilVan

   module Mustache

      def self.registered(app)
         app.const_set :Helpers, Module.new
         app.const_set :Views, Module.new
         rrequire_rdir "app/{helpers,views}"
         app.set :mustache_template_path, File.join('app', 'templates')

         app.send :include, Helpers
      end

      module Helpers

         def view(view)
            @mustache_view = view
         end

         def layout(layout)
            @mustache_layout = layout
         end

         def mustache(template)
            view = @mustache_view || Mustache
            ctx = Context.new(view, self)
            rendered = mustache_template_for(template).render(ctx)

            layout = @mustache_layout
            layout = settings.layout if layout.nil?
            if layout
               ctx.set_yield rendered
               rendered = mustache_template_for(layout).render(ctx)
            end

            rendered
         end

         def mustache_template_for(name)
            @template_cache.fetch(:mustache_template, name) do
               path = File.join(settings.mustache_template_path, name.to_s) +
                     '.mustache'
               ::Mustache::CachedTemplate.new File.read path
            end
         end
      end
   end
end
