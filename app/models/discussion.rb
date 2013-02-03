class Discussion < ActiveRecord::Base

   PUBLIC_GROUPS = ['GeneralDiscussionGroup']

   attr_accessible :name, :messages_attributes

   # ==========================================================================
   # * Relations
   # ==========================================================================
   has_many :messages, dependent: :destroy
   belongs_to :group,
         polymorphic: true,
         foreign_key: 'discussion_group_id',
         foreign_type: 'discussion_group_type'
   has_many :discussion_subscriptions

   accepts_nested_attributes_for :messages

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :name
   validates_length_of :messages, minimum: 1

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def author
      Message.order('messages.created_at ASC').where(discussion_id: id)
            .first.account
   end

   def read_by?(account)
      date = DiscussionView.date_for(account, self)
      !date.nil? and date > updated_at
   end

   def page(number)
      Message.where(discussion_id: id).by_date.page(number)
   end

   def total_pages
      page(1).total_pages
   end
end
