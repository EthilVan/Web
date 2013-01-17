class Message < ActiveRecord::Base

   PER_PAGE = 8

   include EthilVan::Markdown::ActiveRecord

   belongs_to :discussion
   belongs_to :account

   markdown_pre_parse :contents

   paginates_per PER_PAGE

   scope :by_date, order('created_at ASC')

   def page
      messages = Message.
            where(discussion_id: discussion.id).by_date.pluck(:id)
      index = messages.index(id)
      return -1 if index.nil?
      index / PER_PAGE + 1 #/
   end

   def editable_by?(account)
      account.role.inherit? EthilVan::Role::MODO or
            self.account == account
   end
end
