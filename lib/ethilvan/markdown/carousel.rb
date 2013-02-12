module EthilVan::Markdown::Helpers

   module SlideShow

      Regexp = /\A(?:slideshow|carousel)\n(.+)\Z/m

      def image(link, title, alt)
         return super(link, title, alt) unless link =~ Regexp
         @carousel_id = (@carousel_id || 0) + 1
         images = $1.split("\n")
         titles = (title || '').split("\n")
         res = carousel(images, titles, alt).gsub(/\n+/, '')
         res
      end

      def carousel(images, titles, alt)
         <<-CAROUSEL
<div id="md-carousel#@carousel_id" class="carousel slide">
   <div class="carousel-inner">
      #{carousel_items(images, titles, alt)}
   </div>
   <!-- Carousel nav -->
   <a class="carousel-control left" href="#md-carousel#@carousel_id" data-slide="prev">&lsaquo;</a>
   <a class="carousel-control right" href="#md-carousel#@carousel_id" data-slide="next">&rsaquo;</a>
</div>
CAROUSEL
      end

      def carousel_items(images, titles, alt)
         active = true
         images.each_with_index.inject('') do |res, element|
            img, index = *element
            item = carousel_item(img, titles[index], alt, active)
            active = false
            res + item
         end
      end

      def carousel_item(image, title, alt, active)
         active_class = active ? 'active ' : ''
         <<-CAROUSEL_ITEM
      <div class="#{active_class} item">
         <img alt="#{alt}#@carousel_id" src="#{image}" />
         #{carousel_item_title(title)}
      </div>
CAROUSEL_ITEM
      end

      def carousel_item_title(title)
         return '' if title.blank?
         <<-CAROUSEL_ITEM_TITLE
         <div class="carousel-caption">
            <p>#{title}</p>
         </div>
CAROUSEL_ITEM_TITLE
      end
   end

   class ToHTML
      override_image
      include SlideShow
   end
end
