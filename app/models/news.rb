class News < ActiveRecord::Base

   self.table_name = 'newses'

   include EthilVan::Markdown::Helpers

   validates_presence_of :title
   validates_presence_of :contents

   belongs_to :account

   before_save :parse_summary,  :if => :new_summary?
   before_save :parse_contents, :if => :new_contents?

   def summary=(new_summary)
      write_attribute :summary, new_summary
      write_attribute :parsed_summary, nil
   end

   def contents=(new_contents)
      write_attribute :contents, new_contents
      write_attribute :parsed_contents, nil
   end

private

   def new_summary?
      parsed_summary.nil? and !summary.nil?
   end

   def new_contents?
      parsed_contents.nil?
   end

   def parse_summary
      self.parsed_summary = markdown(summary)
   end

   def parse_contents
      self.parsed_contents = markdown(contents)
   end
end
