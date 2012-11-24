rrequire './lib/tasks/html_truncator'

class FillMissingNewsSummaries < ActiveRecord::Migration

   include HtmlTruncator

   def self.up
      News.all.each do |news|
         next unless news.summary.nil?
         news.summary = news.contents[0...700]
         news.parsed_summary = truncate(news.parsed_contents, 700)
         news.save(validate: false)
      end
   end

   def self.down
   end
end
