class Discussion < ActiveRecord::Base

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
   def read_by?(account)
      discussion_view = DiscussionView.for(account, self)
      !discussion_view.nil? and discussion_view.date > updated_at
   end

   def page(number)
      Message.where(discussion_id: id).by_date.page(number)
   end

   def total_pages
      page(1).total_pages
   end
 end
