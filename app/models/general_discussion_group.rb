class GeneralDiscussionGroup < ActiveRecord::Base

   URL_PATTERN = '[a-z][a-z0-9_]*'

   attr_accessible :name
   attr_accessible :url
   attr_accessible :icon
   attr_accessible :description
   attr_accessible :priority

   # ==========================================================================
   # * Relations
   # ==========================================================================
   has_many :discussions, as: :discussion_group,
         order: 'updated_at DESC',
         conditions: 'archived = 0',
         dependent: :destroy

   has_many :archived_discussions, as: :discussion_group,
         class_name: 'Discussion',
         order: 'updated_at DESC',
         conditions: 'archived = 1',
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
   scope :with_everything, includes(discussions:
         { first_message: :account, last_message: :account})

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
