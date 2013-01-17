class News < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord

   self.table_name = 'newses'

   validates_presence_of :title
   validates_presence_of :contents

   belongs_to :account

   markdown_pre_parse :summary
   markdown_pre_parse :contents

   scope :with_account, includes(:account)
   scope :by_date,      order('created_at DESC')
   scope :public_only,  where(private: false)
   scope :with_banners, where('banner != \'\'')
end
