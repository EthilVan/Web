module EthilVan::Mustache

   class Context < ::Mustache::Context

      def initialize(mustache, app)
         super(mustache)
         mustache.app = app
         @app = app
      end

      def partial(name, indentation = '')
         @app.mustache_template_for(name).render(self)
      end

      def push(new)
         new.app = @app if new.respond_to? :app
         super(new)
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
