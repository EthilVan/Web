class AddParsedMarkdownFields < ActiveRecord::Migration

   def self.up
      add_column(:newses,   :parsed_summary,  :text, default: nil)
      add_column(:newses,   :parsed_contents, :text, default: nil)
      add_column(:messages, :parsed_contents, :text, default: nil)

      News.reset_column_information
      News.all.each do |news|
         news.send :parse_summary unless news.summary.nil?
         news.send :parse_contents
         news.save
      end

      Message.reset_column_information
      Message.record_timestamps = false
      Message.all.each do |message|
         message.send :parse_contents
         message.save
      end
      Message.record_timestamps = true
   end

   def self.down
      remove_column(:newses,   :parsed_summary)
      remove_column(:newses,   :parsed_contents)
      remove_column(:messages, :parsed_contents)
   end
end
