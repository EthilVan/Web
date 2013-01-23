class Message < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord

   PER_PAGE = 8
   paginates_per PER_PAGE

   attr_accessible :contents

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :discussion
   belongs_to :account

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :contents

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :contents

   scope :by_date, order('created_at ASC')

   # ==========================================================================
   # * Methods
   # ==========================================================================
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
