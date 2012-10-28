module EthilVan::Mustache

   class Partial < ::Mustache

      self.template_path = File.join(EthilVan::ROOT, "app", "templates")

      attr_accessor :app

      def p(partial)
         partial.app = app
         partial
      end
   end
end
