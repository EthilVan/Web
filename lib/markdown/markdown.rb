module EthilVan

   module Markdown

      def self.registered(app)
         app.send :include, Helpers
      end

      module Helpers

         def linkify_mention(text)
            text.gsub(/@([A-Za-z]\w+)/) do |m|
               a = Account.find_by_name $1
               a.nil? ? m : <<-END
<a class=\"membre_mention\" href=\"/membre/@#{a.name}\">
   #{m}
</a>
               END
            end
         end

         def markdown(msg)
            linkify_mention render_markdown msg
         end

         def markdown_xhtml
            linkify_mention render_xmarkdown msg
         end
      end
   end
end

if RUBY_PLATFORM == 'java'
   require_relative 'jruby'
else
   require_relative 'redcarpet'
end
