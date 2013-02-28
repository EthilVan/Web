require 'action_view'

module EthilVan::Mustache

   class Partial < ::Mustache

      include ActionView::Helpers::DateHelper

      attr_accessor :app

      def partial(name)
         @app.mustache_context.partial(name)
      end
   end
end
