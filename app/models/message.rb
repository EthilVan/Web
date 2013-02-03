class Message < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord

   DISCUSSION_GROUP_KEY = 'discussions.discussion_group_type'
   PER_PAGE = 8
   paginates_per PER_PAGE

   attr_accessible :contents

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account
   belongs_to :discussion
   has_one :discussion_as_first,
         foreign_key: :first_message_id,
         class_name: 'Discussion'
   has_one :discussion_as_last,
         foreign_key: :last_message_id,
         class_name: 'Discussion'

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :contents

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :contents
   after_create  :update_discussion

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

   def first_message?
      not discussion_as_first.nil?
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

   def destroy
      super
      update_discussion_last
   end

private

   def update_discussion
      return if discussion.nil?
      discussion.last_message_id = id
      discussion.save
   end

   def update_discussion_last
      return if discussion_as_last.nil?
      discussion_as_last.update_last_message
   end
end
