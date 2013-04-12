require 'redcarpet'

module EthilVan::Markdown::Helpers

   class RubyHTML < Redcarpet::Render::HTML

      def self.image(link, title, alt, classes = [])
         img = "<img src=\"#{link}\""
         img << " alt=\"#{alt}\"" if alt
         img << " title=\"\#{title}\"" if title
         img << " class=\"#{classes * " "}\"" unless classes.empty?
         img << "/>"
         img
      end

      def self.override_image
         return if RubyHTML.method_defined? :image
         RubyHTML.class_eval(<<-OVERRIDDEN_IMAGE)
            def image(*args)
               self.class.image(*args)
            end
         OVERRIDDEN_IMAGE
      end
   end

   class ToHTML < RubyHTML

      HtmlOptions = {
         filter_html:     true,
         with_toc_data:   true,
         hard_wrap:       true,
         xhtml:           true,
      }

      include Redcarpet::Render::SmartyPants

      def initialize(options = HtmlOptions)
         super(options)
      end
   end

   Options = {
      tables:                 true,
      autolink:               true,
      strikethrough:          true,
      lax_html_blocks:        true,
      space_after_headers:    true,
   }

   def render_markdown(source)
      Redcarpet::Markdown.new(ToHTML,  Options).render(source)
   end
end
