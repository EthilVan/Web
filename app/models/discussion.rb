class Discussion < ActiveRecord::Base

   include Activity::Subject

   PUBLIC_GROUPS = ['GeneralDiscussionGroup']

   attr_accessible :name
   attr_accessible :first_message_attributes
   attr_accessible :new_group_id
   attr_accessible :archived

   # ==========================================================================
   # * Relations
   # ==========================================================================
   has_one :first_message, class_name: 'Message', conditions: 'first = 1',
         include: :account, autosave: false
   has_one :last_message,  class_name: 'Message', conditions: 'last = 1',
         include: :account, autosave: false
   has_many :messages, order: 'created_at ASC', dependent: :destroy
   belongs_to :group,
         polymorphic: true,
         foreign_key: 'discussion_group_id',
         foreign_type: 'discussion_group_type'
   has_many :discussion_subscriptions

   accepts_nested_attributes_for :first_message

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :name
   validate :new_group_existence, if: :new_group?
   validates_associated :messages, on: :create
   validates_length_of  :messages, minimum: 1

   # ==========================================================================
   # * Activity
   # ==========================================================================
   activities_includes :group
   activities_filter :feed, :moved, :archived, :unarchived do
         |viewer, subject, activity|
      activity.actor.id == viewer.id or
            viewer.subscripted_group_ids.include?(subject.group.id) or
            viewer.subscripted_discussion_ids.include?(subject.id)
   end

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   before_validation :init_first_last_messages, on: :create
   before_save :update_group, if: :new_group?

   # ==========================================================================
   # * Methods
   # ==========================================================================
   attr_writer :new_group_id

   def new_group_id
      @new_group_id || discussion_group_id
   end

   def author
      first_message.account
   end

   def page(number)
      Message.where(discussion_id: id).by_date.page(number)
   end

   def total_pages
      page(1).total_pages
   end

private

   def new_group?
      persisted? and @new_group_id.present?
   end

   def new_group_existence
      new_group = group.class.find_by_id @new_group_id
      return unless new_group.nil?
      errors.add(:new_group_id, :inclusion)
   end

   def update_group
      self.discussion_group_id = @new_group_id
   end

   def init_first_last_messages
      first_message.first = true
      self.messages = [first_message]
   end
end
