class Discussion < ActiveRecord::Base

   PUBLIC_GROUPS = ['GeneralDiscussionGroup']

   attr_accessible :name

   # ==========================================================================
   # * Relations
   # ==========================================================================
   has_many :messages
   belongs_to :group,
         polymorphic: true,
         foreign_key: 'discussion_group_id',
         foreign_type: 'discussion_group_type'
   has_many :discussion_subscriptions

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :name

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

   def destroy_with_messages
      Message.where(discussion_id: id).destroy_all
      destroy
   end
end
