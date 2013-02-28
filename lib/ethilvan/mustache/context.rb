module EthilVan::Mustache

   class Context < ::Mustache::Context

      def initialize(mustache, app)
         super(mustache)
         mustache.app = app
         @app = app
         app.mustache_context = self
      end

      def partial(name, indentation = '')
         @app.mustache_template_for(name).render(self)
      end

      def push(elem)
         elem.app = @app if elem.respond_to? :app
         super elem
      end
      alias_method :update, :push

      def fetch(name, default = :__raise)
         return @yield if name == :yield
         super(name, default)
      end

      def set_yield(_yield)
         @yield = _yield
      end
   end
end
