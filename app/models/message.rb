class Message < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord

   belongs_to :discussion
   belongs_to :account

   markdown_pre_parse :contents

   paginates_per 8

   def editable_by?(account)
      account.role.inherit? EthilVan::Role::MODO or
            self.account == account
   end
end
