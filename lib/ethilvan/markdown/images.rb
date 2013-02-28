module EthilVan::Markdown::Helpers

   module ImagesClasses

      classes = [
         "centre",
         "droite",
      ] * '|'

      Regexp = /\A((?:#{classes})(?:,(?:#{classes}))*) (.+)\Z/m

      def image(link, title, alt)
         return super(link, title, alt) unless link =~ Regexp
         classes = $1.split(',').uniq.map { |klass| "md-img-#{klass}" }
         return self.class.image($2, title, alt, classes)
      end
   end

   class ToHTML
      override_image
      include ImagesClasses
   end
end
