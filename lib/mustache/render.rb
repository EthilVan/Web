require 'mustache'

module EthilVan

   module Mustache

      def self.registered(app)
         app.const_set :Helpers, Module.new
         app.const_set :Views, Module.new
         rrequire_rdir "app/helpers"
         rrequire_rdir "app/views"

         app.send :include, Helpers
      end

      module Helpers

         def view(view)
            view.app = self
            @mustache_view = view
         end

         def layout(layout)
            @mustache_layout = layout
         end

         def mustache(template)
            template_path = filepath_for template
            view = @mustache_view || Mustache
            rendered = view.render File.read template_path

            layout = @mustache_layout
            layout = settings.layout if layout.nil?

            if layout
               layout_path = filepath_for layout
               rendered = view.render File.read(layout_path),
                     :yield => rendered
            end

            rendered
         end

      private

         def filepath_for(template)
            File.join("app", "templates", template) + ".mustache"
         end
      end
   end
end
