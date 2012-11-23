class Message < ActiveRecord::Base

   include EthilVan::Markdown::Helpers

   before_save :parse_contents, :if => :new_contents?

   def contents=(new_contents)
      write_attribute :contents, new_contents
      write_attribute :parsed_contents, nil
   end

private

   def new_contents?
      parsed_contents.nil?
   end

   def parse_contents
      self.parsed_contents = markdown(contents)
   end
end
