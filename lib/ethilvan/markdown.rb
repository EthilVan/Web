module EthilVan

   module Markdown

      def self.registered(app)
         app.send :include, Helpers
      end

      module Helpers

         def markdown(msg)
            linkify_mention render_markdown msg
         end

         def markdown_xhtml
            linkify_mention render_xmarkdown msg
         end

      private

         def linkify_mention(text)
            text.gsub(/@([A-Za-z]\w+)/) do |mention|
               account = Account.find_by_name $1
               account.nil? ? mention : <<-END
<a class=\"membre_mention\" href=\"/membre/@#{account.name}\">#{mention}</a>
               END
            end
         end
      end
   end
end

require 'ethilvan/markdown/redcarpet'
