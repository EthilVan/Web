class News < ActiveRecord::Base

   include EthilVan::Markdown::ActiveRecord
   include Activity::Subject

   self.table_name = 'newses'

   attr_accessible :title
   attr_accessible :banner
   attr_accessible :summary
   attr_accessible :contents
   attr_accessible :important
   attr_accessible :private
   attr_accessible :commentable
   attr_accessible :categories

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
   validate :theres_at_least_one_category

   # ==========================================================================
   # * Callbacks and scope
   # ==========================================================================
   markdown_pre_parse :summary
   markdown_pre_parse :contents
   before_save :update_categories_int, if: :categories_updated?

   scope :with_account, includes(:account)
   scope :by_date,      order('created_at DESC')
   scope :public_only,  where(private: false)
   scope :has_banner,   where('banner != \'\'')

   # ==========================================================================
   # * Methods
   # ==========================================================================
   attr_accessor :important

   def initialize(*args)
      @important = false
      super(*args)
   end

   def categories
      @categories || NewsCategories.new(categories_int)
   end

   def categories=(names)
      @categories = NewsCategories.new_from_names(*names)
   end

private

   def theres_at_least_one_category
      return unless new_record?
      @categories ||= []
      if @categories.size < 1
         errors.add(:categories, :too_short, count: @categories.size)
      end
   end

   def categories_updated?
      not @categories.nil?
   end

   def update_categories_int
      write_attribute :categories_int, @categories.value
   end
end
