require 'builder'

module EthilVan::App::Views

   module Public::News

      class Feed

         def initialize(newses)
            @newses = newses
         end

         def to_xml
            builder = Builder::XmlMarkup.new
            builder.instruct! :xml, version: "1.0", encoding: "UTF-8"
            builder.rss(version: "2.0") { channel(builder) }
         end

         def channel(builder)
            builder.channel do |channel|

               channel.title "Ethil Van News"
               channel.description "EthilVan News Feed"
               channel.link "http://ethilvan.fr/news"
               channel.language "fr"
               channel.lastBuildDate News.maximum(:updated_at).to_datetime

               @newses.each do |news|
                  channel.item { |item| item(item, news) }
               end
            end
         end

         def item(item, news)
            item.title news.title
            item.link "http://ethilvan.fr/news/#{news.id}"
            item.pubDate news.created_at.to_datetime
            item.description news.parsed_summary
         end
      end
   end
end
