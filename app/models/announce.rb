class Announce < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord
   include Activity::Subject

   attr_accessible :content

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :content

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :content
   scope :by_date, order('created_at DESC')
end
