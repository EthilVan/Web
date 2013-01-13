class Message < ActiveRecord::Base

   belongs_to :discussion
   belongs_to :account

   include EthilVan::Markdown::Helpers

   before_save :parse_contents, if: :new_contents?

   paginates_per 8

   def contents=(new_contents)
      write_attribute :contents, new_contents
      write_attribute :parsed_contents, nil
   end

   def editable_by?(account)
      account.role.inherit? EthilVan::Role::MODO or
            self.account == account
   end

private

   def new_contents?
      parsed_contents.nil?
   end

   def parse_contents
      self.parsed_contents = markdown(contents)
   end
end
