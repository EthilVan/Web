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
            record_mentions = respond_to? :parsed_mentions
            text.gsub(/@([A-Za-z]\w+)/) do |mention|
               account = Account.find_by_name $1
               next(mention) if account.nil?
               parsed_mentions << account if record_mentions
               <<-END
<a class=\"membre_mention\" href=\"/membre/#{mention}\">#{mention}</a>
               END
            end
         end

         def emojify(text)
            text.gsub(/:([a-z0-9\+\-_]+):/) do |match|
               next(match) unless EthilVan::Emoji.names.include?($1)
               <<-END
<img class="emoji" alt=\"emoji-#{$1}" title=":#{$1}:"
      src="/images/emoji/#{$1}.png" />
               END
            end
         end
      end
   end
end

require 'ethilvan/markdown/redcarpet'
require 'ethilvan/markdown/images'
require 'ethilvan/markdown/oembed'
require 'ethilvan/markdown/carousel'
require 'ethilvan/markdown/active_record'
require 'ethilvan/markdown/field'
