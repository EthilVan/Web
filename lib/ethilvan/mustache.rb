require 'mustache'

require 'ethilvan/mustache/context'
require 'ethilvan/mustache/template'
require 'ethilvan/mustache/partial'
require 'ethilvan/mustache/form'

module EthilVan

   module Mustache

      def self.registered(app)
         app.const_set(:Views, Module.new) unless app.const_defined? :Views
         app.helpers Helpers
         app.set :mustache_templates, 'templates'
      end

      module Helpers

         def view(view)
            @mustache_view = view
         end

         def mail_view(mail_view)
            @mustache_mail_view = mail_view
         end

         def layout(layout)
            @mustache_layout = layout
         end

         def mustache(template, params = {})
            view = params[:view] || @mustache_view || Mustache
            ctx = Context.new(view, self)
            rendered = mustache_template_for(template).render(ctx)

            unless params[:no_layout]
               layout = @mustache_layout
               layout = settings.layout if layout.nil? and !xhr?
               if layout
                  ctx.set_yield rendered
                  rendered = mustache_template_for(layout).render(ctx)
               end
            end

            rendered
         end

         def mail_mustache(template)
            mustache("mails/#{template}",
                  view: @mustache_mail_view || Mustache,
                  no_layout: true)
         end

         def mustache_template_for(name)
            @template_cache.fetch(:mustache_template, name) do
               path = File.join(settings.mustache_templates, name.to_s) +
                     '.mustache'
               ::Mustache::CachedTemplate.new File.read path
            end
         end
      end
   end
end
