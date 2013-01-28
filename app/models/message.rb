class Message < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord

   DISCUSSION_GROUP_KEY = 'discussions.discussion_group_type'
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
   after_create :update_discussion
   scope :by_date, order('created_at ASC')

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def self.for_account(account)
      joins(:discussion)
            .includes(:discussion)
            .where(account_id: account.id)
            .where(DISCUSSION_GROUP_KEY => Discussion::PUBLIC_GROUPS)
            .order('messages.created_at DESC')
   end

   def page
      messages = Message.
            where(discussion_id: discussion.id).by_date.pluck(:id)
      index = messages.index(id)
      return -1 if index.nil?
      index / PER_PAGE + 1 #/
   end

   def following
      messages = Message.where(discussion_id: discussion_id).
            pluck(:id)
      found = false
      next_id = nil
      messages.each do |msg_id|
         next_id = msg_id unless msg_id == id
         break if found
         found = true if msg_id == id
      end
      Message.find_by_id next_id
   end

   def editable_by?(account)
      account.role.inherit? EthilVan::Role::MODO or
            self.account == account
   end

private

   def update_discussion
      return if discussion.nil?
      discussion.update_attribute :updated_at, created_at
    end
end
