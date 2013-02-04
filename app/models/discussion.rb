class Discussion < ActiveRecord::Base

   PUBLIC_GROUPS = ['GeneralDiscussionGroup']

   attr_accessible :name
   attr_accessible :first_message_attributes

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
   validates_associated :first_message, on: :create
   validates_length_of :messages, minimum: 1

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   before_validation :assign_first_message, on: :create

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def author
      first_message.account
   end

   def page(number)
      Message.where(discussion_id: id).by_date.page(number)
   end

   def total_pages
      page(1).total_pages
   end

   def assign_first_message
      self.messages = [first_message]
      self.last_message = first_message
   end

   def update_last_message
      update_attribute :last_message_id, messages.last(2)[0].id
   end
end
