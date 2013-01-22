class GeneralDiscussionGroup < ActiveRecord::Base

   # ==========================================================================
   # * Relations
   # ==========================================================================
   has_many :discussions, as: :discussion_group, order: 'updated_at DESC'

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :name
   validates_format_of   :url, with: /\A[A-Za-z_]+\Z/

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   scope :by_priority, order('priority ASC')

   # ==========================================================================
   # * Methods
   # ==========================================================================
   def discussions_with_limit(limit)
      discussions_query.limit(5).order('updated_at DESC')
   end

   def discussions_count
      discussions_query.count
   end

private

   def discussions_query
      ::Discussion.where(discussion_group_id: id,
            discussion_group_type: self.class.name)
   end
end
