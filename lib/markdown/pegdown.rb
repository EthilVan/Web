module EthilVan::Markdown::Helpers

   java_import org.pegdown.PegDownProcessor
   java_import org.pegdown.Extensions

   options = Extensions.SMARTYPANTS |
         Extensions.ABBREVIATIONS |
         Extensions.HARDWRAPS |
         Extensions.AUTOLINKS |
         Extensions.TABLES |
         Extensions.SUPPRESS_ALL_HTML

   Processor = PegDownProcessor.new(options)

   def markdownify(source, xhtml = false)
      Processor.markdown_to_html(source)
   end
end
