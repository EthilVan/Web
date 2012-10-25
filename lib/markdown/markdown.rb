module EthilVan

   module Markdown

      def self.registered(app)
         app.send :include, Helpers
      end

      module Helpers

         def linkify_mention(text)
            text.gsub(/@([A-Za-z]\w+)/) do |m|
               a = Account.find_by_name $1
               if a.nil?
                  m
               else
                  "<a class=\"membre_mention\" href=\"/membre/@#{a.name}\">#{m}</a>"
               end
            end
         end

         def markdown(msg, xhtml = false)
            linkify_mention markdownify msg
         end
      end
   end
end

if RUBY_PLATFORM == 'java'
   rrequire 'lib/markdown/pegdown'
else
   rrequire 'lib/markdown/redcarpet'
end
