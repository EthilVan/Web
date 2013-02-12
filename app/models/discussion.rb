class Discussion < ActiveRecord::Base

   PUBLIC_GROUPS = ['GeneralDiscussionGroup']

   attr_accessible :name
   attr_accessible :first_message_attributes
   attr_accessible :new_group_id

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :first_message, class_name: 'Message', include: :account
   belongs_to :last_message,  class_name: 'Message', include: :account
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
   validates_associated :first_message, on: :create
   validates_length_of :messages, minimum: 1

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   before_validation :assign_first_message, on: :create
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

   def update_last_message
      update_attribute :last_message_id, messages.last(2)[0].id
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

   def assign_first_message
      self.messages = [first_message]
      self.last_message = first_message
   end
end
