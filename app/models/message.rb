class Message < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord
   include Activity::Subject

   DISCUSSION_GROUP_KEY = 'discussions.discussion_group_type'
   PER_PAGE = 8
   paginates_per PER_PAGE

   attr_accessible :contents

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account
   belongs_to :discussion
   has_many :mentions, class_name: 'MessageMention', dependent: :destroy

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :contents

   # ==========================================================================
   # * Activity
   # ==========================================================================
   activities_includes :account

   activities_filter :feed, :create do |viewer, subject, activity|
      discussion = subject.discussion
      activity.viewer_is_actor?(viewer) or
            discussion.followed_by?(viewer) or
            discussion.group.activity_viewable_by?(viewer)
   end

   activities_filter :feed, :edit do |viewer, subject, activity|
      [subject.account.id, activity.actor.id].include? viewer.id
   end

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :contents
   before_create  :update_discussion_last_before_create
   after_create   :update_discussion_last_after_create
   after_update   :update_discussion_last_on_update
   after_destroy  :update_discussion_last_on_destroy

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

   def parsed_mentions
      @parsed_mentions ||= []
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
            (!discussion.archived? and self.account == account)
   end

private

   def update_discussion_last_before_create
      self.last = true
   end

   def update_discussion_last_after_create
      return if discussion.nil?
      last_message = discussion.last_message
      return if last_message.nil?
      return if self == last_message
      last_message.update_attribute :last, false
   end

   def update_discussion_last_on_update
      return unless first? or last?
      discussion.update_attribute :updated_at, updated_at
   end

   def update_discussion_last_on_destroy
      return unless last?
      return if discussion.nil?
      previous_message = discussion.messages.last(2)[0]
      return if previous_message.nil?
      previous_message.update_attribute :last, true
   end
end
