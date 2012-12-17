require 'redcarpet'

module EthilVan::Markdown::Helpers

   class ToHTML < Redcarpet::Render::HTML

      HtmlOptions = {
         filter_html:     true,
         with_toc_data:   true,
         hard_wrap:       true,
      }

      include Redcarpet::Render::SmartyPants

      def initialize(options = HtmlOptions)
         super(options)
      end
   end

   class ToXHTML < ToHTML

      XHtmlOptions = HtmlOptions.clone
      XHtmlOptions[:xhtml] = true

      def initialize
         super(XHtmlOptions)
      end
   end

   Options = {
      no_intra_emphasis:      true,
      tables:                 true,
      autolink:               true,
      strikethrough:          true,
      lax_html_blocks:        true,
      space_after_headers:    true,
   }

   def render_markdown(source)
      Redcarpet::Markdown.new(ToHTML,  Options).render(source)
   end

   def render_xmarkdown(source)
      Redcarpet::Markdown.new(ToXHTML, Options).render(source)
   end
end
