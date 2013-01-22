class News < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord

   self.table_name = 'newses'

   # ==========================================================================
   # * Relations
   # ==========================================================================
   belongs_to :account

   # ==========================================================================
   # * Validations
   # ==========================================================================
   validates_presence_of :title
   validates_presence_of :summary
   validates_presence_of :contents
   validates_format_of   :banner, with: /^#{URI::regexp(%w(http https))}$/,
         if: Proc.new { |m| m.banner.present? }

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
