class GeneralDiscussionGroup < ActiveRecord::Base

   URL_PATTERN = '[a-z][a-z0-9_]*'

   attr_accessible :name
   attr_accessible :description
   attr_accessible :priority
   attr_accessible :url

   # ==========================================================================
   # * Relations
   # ==========================================================================
   has_many :discussions, as: :discussion_group, order: 'updated_at DESC'

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :name
   validates_format_of   :url, with: /\A#{URL_PATTERN}\Z/

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

   def destroy_with_everything
      discussions.each &:destroy_with_messages
      destroy
   end

private

   def discussions_query
      ::Discussion.where(discussion_group_id: id,
            discussion_group_type: self.class.name)
   end
end
