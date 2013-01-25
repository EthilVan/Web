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
               next(mention) unless Account.exists? name: $1
               <<-END
<a class=\"membre_mention\" href=\"/membre/#{mention}\">#{mention}</a>
               END
            end
         end
      end
   end
end

require 'ethilvan/markdown/redcarpet'
require 'ethilvan/markdown/oembed'
require 'ethilvan/markdown/active_record'
