class News < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord

   self.table_name = 'newses'

   attr_accessible :title
   attr_accessible :banner
   attr_accessible :summary
   attr_accessible :contents
   attr_accessible :important
   attr_accessible :private
   attr_accessible :commentable

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account
   has_many :comments, class_name: 'NewsComment', order: 'created_at DESC',
         dependent: :destroy

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :title
   validates_presence_of :summary
   validates_presence_of :contents
   validates_format_of   :banner, with: /^#{URI::regexp(%w(http https))}$/,
         allow_blank: true

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :summary
   markdown_pre_parse :contents

   scope :with_account, includes(:account)
   scope :by_date,      order('created_at DESC')
   scope :public_only,  where(private: false)
   scope :has_banner, where('banner != \'\'')
end
