module EthilVan::Mustache

   class Partial < ::Mustache

      self.template_path = File.join(EthilVan::ROOT, "app", "templates")

      attr_accessor :app

      def partial(partial)
         partial.app = app
         partial
      end
   end
end
