module EthilVan::Markdown::Helpers

   class ToHTML < Redcarpet::Render::HTML

      HtmlOptions = {
         filter_html: true,
         with_toc_data: true,
         hard_wrap: true
      }

      include Redcarpet::Render::SmartyPants

      def initialize(options = HtmlOptions)
         super(options)
      end

      def normal_text(text)
         EthilVan::Markdown.linkify_mention(text) unless text.nil?
      end
   end

   class ToXHTML < MarkdownToHTML

      XHtmlOptions = HtmlOptions.clone
      XHtmlOptions[:xhtml] = true

      def initialize
         super(XHtmlOptions)
      end
   end

   Options = {
      no_intra_emphasis: true,
      tables: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      space_after_headers: true
   }

   HtmlRenderer  = Redcarpet::Markdown.new(ToHTML,  Options)
   XHtmlRenderer = Redcarpet::Markdown.new(ToXHTML, Options)

   def markdownify(msg, xhtml = false)
      xhtml ? XHtmlRenderer.render(source) : HtmlRenderer.render(source)
   end
end
