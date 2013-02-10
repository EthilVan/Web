module EthilVan

   module Markdown

      def self.registered(app)
         app.send :include, Helpers
      end

      module Helpers

         def markdown(msg)
            emojify linkify_mention render_markdown msg
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

         def emojify(text)
            text.gsub(/:([a-z0-9\+\-_]+):/) do |match|
               next(match) unless EthilVan::Emoji.names.include?($1)
               <<-END
<img class="emoji" alt=\"emoji-#{$1}" height="20" src="/images/emoji/#{$1}.png" />
               END
            end
         end
      end
   end
end

require 'ethilvan/markdown/redcarpet'
require 'ethilvan/markdown/oembed'
require 'ethilvan/markdown/active_record'
require 'ethilvan/markdown/field'
