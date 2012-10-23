module EthilVan::Mustache

   class Partial < ::Mustache

      self.template_path = File.join(EthilVan::ROOT, "templates")
   end
end
