# encoding: utf-8

require 'builder'

module EthilVan::Markdown::Helpers

   module SlideShow

      Regexp = /\A(?:slideshow|carousel)\n(.+)\Z/m

      def image(link, title, alt)
         return super(link, title, alt) unless link =~ Regexp
         HTML.new($1.split("\n"), (title || '').split("\n"), alt).render
      end

      class HTML

         def initialize(images, titles, alt)
            @id = rand(100_000)
            @images = images
            @titles = titles
            @alt = alt
         end

         def html_id
            "md-carousel#@id"
         end

         def render
            builder = Builder::XmlMarkup.new
            builder.div id: html_id, class: "carousel slide" do |carousel|
               carousel.div class: "carousel-inner" do |inner|
                  carousel_items inner
               end
               control(carousel, "left",  "prev", "‹")
               control(carousel, "right", "next", "›")
            end
         end

         def carousel_items(inner)
            active = true
            @images.each_with_index do |image, index|
               inner.div class: "#{active ? 'active ' : ''}item" do |item|
                  carousel_item(item , image, index)
               end
               active = false
            end
         end

         def carousel_item(item, image, index)
            item.img alt: @alt, src: image
            title = @titles[index]
            return if title.blank?
            item.div class: "carousel-caption" do |caption|
               caption.p title
            end
         end

         def control(container, side, data_slide, contents)
            container.a({
               :href         => '#' + html_id,
               :class        => "carousel-control #{side}",
               :"data-slide" => data_slide,
            }, contents)
         end
      end
   end

   class ToHTML
      override_image
      include SlideShow
   end
end
