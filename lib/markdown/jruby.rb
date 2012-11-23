begin
   require_relative 'jruby-markdown.jar'
rescue LoadError
   puts 'Unable to load "jruby-markdown.jar"'
   puts 'Try running "rake jruby:install"'
end

module EthilVan::Markdown::Helpers

   JRubyMarkdown = Java::FrEthilvanMarkdown::Markdown

   def render_markdown(source)
      JRubyMarkdown.render(source)
   end
   alias_method :render_xmarkdown, :render_markdown
end
