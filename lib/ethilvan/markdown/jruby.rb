require 'jruby-pegdown'

module EthilVan::Markdown::Helpers

   include JRubyPegdown

   def render_markdown(source)
      Markdown.render(source).encode('UTF-8')
   end
   alias_method :render_xmarkdown, :render_markdown
end