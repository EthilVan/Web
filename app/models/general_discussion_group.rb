class GeneralDiscussionGroup < ActiveRecord::Base

   URL_PATTERN = '[a-z][a-z0-9_]*'

   attr_accessible :name
   attr_accessible :description
   attr_accessible :priority
   attr_accessible :url

   # ==========================================================================
   # * Relations
   # ==========================================================================
   has_many :discussions, as: :discussion_group,
         order: 'updated_at DESC',
         dependent: :destroy

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
   def discussions_ordered
      discussions.order('updated_at DESC')
   end

   def discussions_count
      discussions.count
   end
end
